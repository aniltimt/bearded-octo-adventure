class Quoting::QuotesController < ApplicationController
  respond_to :html, :js
  append_view_path 'app/views/quoting/quotes'
  before_filter :require_login_or_user_id!

  helper_method :quotes_form_action

  # Render a quote form for new Connection
  def new
    @connection = Crm::Connection.new
    @connection.agent = params[:agent_id].present? ? Usage::User.find(params[:agent_id]) : current_user
    @connection.profile = params[:profile_id] || @connection.agent.current_profile_id(cookies)
    _new_or_edit
  end

  # Render a quote form for existing Connection
  def edit
    @connection = Crm::Connection.find params[:id] || params[:connection_id]
    _new_or_edit
  end

  # Save Connection. Update form action of step 1 to 'update' instead of 'create'
  # Render quoting results from PinneyQuoter (step 2) unless params[:dest].present?
  def create
    @connection = Crm::Connection.new params[:connection]
    _create_or_update
  end

  alias_method :bypass_health_analyzer, :create

  def update
    Net::HTTP.enable_debug! 
    @connection = Crm::Connection.find params[:id]
    @connection.attributes = params[:connection]
    _create_or_update
  end

  private

    # Build associated models for forms in view
    def _new_or_edit
      @connection.build_contact_info unless @connection.contact_info.present?
      @connection.build_financial_info unless @connection.financial_info.present?
      @connection.build_health_info unless @connection.health_info.present?
      @connection.health_info.build_moving_violation_history unless @connection.health_info.moving_violation_history.present?
      @connection.health_info.build_health_history unless @connection.health_info.health_history.present?
      @case = Crm::Case.new params[:crm_case], crm_connection:@connection
      @case.build_quoted_details(face_amount:750000) unless @case.quoted_details.present?
    end

    def _create_or_update
      Rails.logger.info params.to_yaml
      
      # handle existing coverage (eliminate unneeded Cases)
      params[:connection][:cases_attributes].delete(:replacing) unless params[:is_replacing] == 'replacing'
      params[:connection][:cases_attributes].delete(:adding) unless params[:is_replacing] == 'adding'
      # handle (non-children) bene
      params[:crm_case][:beneficiaries_attributes].delete(:spouse) unless params[:protect_whom] == 'spouse/partner'
      params[:crm_case][:beneficiaries_attributes].delete(:business) unless params[:protect_whom] ==  'business'
      params[:crm_case][:beneficiaries_attributes].delete(:other) unless params[:protect_whom] == 'other'
      # handle children
      if child_count = params[:child_count].to_i rescue nil
        child_count -= @connection.children.count
        child_count.times{ @connection.children.create }
      end
      if @connection.save
        case params[:dest]
        when 'bypass_health_analyzer'
          redirect_to controller:'/quoting/leads', action:'new_quote', connection_id:@connection, container:'#main-container'
        when 'connection_summary'
          redirect_to controller:'/crm/connections', action:'connection_summary', id:@connection, container:'#main-container'
        else
          _results
        end
      else
        _compile_error_messages @case
        @errors = @connection.errors.full_messages
      end
    end

    def _results
      @case ||= Crm::Case.new params[:crm_case]
      @case.crm_connection ||= @connection
      if @case.valid_quoter?
        @results = Quoting::PinneyQuoter::Quote.fetch_results(@case)
      else
        _compile_error_messages @case
        @errors = @case.errors.full_messages
      end
      # render response
      if @results.is_a? Array and @results.present?
        return render 'create'
      end
      if @errors
        render js: "showQuoterPane(); showFromSiblings('#basic_info'); alert(\"#{ @errors.join('\n') }\");"
      elsif @results.try(:errors)
        render js: "showQuoterPane(); showFromSiblings('#basic_info'); alert(\"#{ @results.errors.full_messages }\");"
      else
        render js: %Q($('#quotes').html("No quotes found for your parameters."))
      end
    end

    # Returns an appropriate action for the quoter form
    def quotes_form_action
      if @connection.new_record?
        {controller:'quoting/quotes', action:'create'}
      else
        {controller:'quoting/quotes', action:'update'}
      end
    end

    # For a given object, adds error messages for associated objects to object.errors
    def _compile_error_messages obj
      errors_from_child = {}
      obj.errors.each{|k,v|
        if obj.class.reflect_on_association k
          relative_object = obj.send(k)
          if relative_object.nil?
            obj.errors[k] = 'cannot be nil'
          else
            _compile_error_messages obj.send k
            obj.send(k).errors.each{|kk,vv|
              errors_from_child[kk] = vv
            }          
            obj.errors.delete k
          end
        end
      }
      errors_from_child.each{|k,v|
        obj.errors[k] << v
      }
    end

    def require_login_or_user_id!
      require_login unless params[:agent_id].present?
    end

end