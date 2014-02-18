class Quoting::LeadsController < ApplicationController
  before_filter :require_user_can_edit_connection, only:[:new, :create, :new_quote, :create_quote]
  before_filter :require_user_can_edit_case, only:[:edit, :update]
  respond_to :html, :js, :json

  def new
    @case = Crm::Case.new params[:crm_case]
    @case.crm_connection = @connection
    @case.build_quoted_details
  end

  def temp
    redirect_to 'http://localhost:3000/crm/connections/connection_summary.js?case_id=95&connection_tab=cases_index'
  end

  def create
  #   redirect_to 'http://localhost:3000/crm/connections/connection_summary.js?case_id=95&connection_tab=cases_index'
  # end

  # def foo
    @connection = Crm::Connection.find params[:crm_connection_id]
    @connection.agent_id ||= current_user.id
    @connection.attributes = params[:crm_connection]
    if @connection.save
      @case = Crm::Case.new params[:crm_case]
      @case.connection_id = @connection.id
      @case.crm_connection = @connection
      @case.agent_id ||= current_user.id
      @case.active = true
      if @case.save
        # respond_with @case
        # respond_to do |fmt|
        #   fmt.html { render text: "<pre>#{params.to_yaml}</pre>" }
        #   fmt.js {
            redirect_to url_for(controller:'/crm/connections',
              action:'connection_summary',
              case_id:@case,
              connection_tab:'cases_index',
              format:'js')
        #   }
        # end
      else
        @errors = @case.errors
        respond_with @errors
      end
    else
      @errors = @connection.errors
      respond_with @errors
    end
  end

  # This method is used for 'Bypass Health Analyzer'
  alias_method :new_quote, :new

  def create_quote
    @connection = Crm::Connection.create agent_id:current_user.id
    @case = Crm::Case.new params[:crm_case]
    @case.connection_id = @connection.id
    @case.crm_connection = @connection
    if @case.save
      redirect_to action:'edit',
        format:params[:format],
        id:@case.id
    else
      @errors = @case.errors
      respond_with @errors
    end
  end

  def edit
    params[:container] ||= '#lead_pane'
  end

  def update
    @case.update_attributes params[:crm_case]
  end

  private

    def require_user_can_edit_connection
      @connection = Crm::Connection.find params[:crm_connection_id] || params[:connection_id] || params[:id]
      unless @connection.try :editable?, params[:agent_id] || current_user.id
        permission_denied
      end
    end

    def require_user_can_edit_case
      @case = Crm::Case.find params[:crm_case_id] || params[:case_id] || params[:id]
      unless @case.try :editable?, params[:agent_id] || current_user.id
        permission_denied
      end
    end

end
