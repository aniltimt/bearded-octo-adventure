class Crm::CasesController < Crm::CrmBaseController

  before_filter :require_crm_case, :determine_container, :only => [:details, :owner, :exam, :exam_completion, :health,
                :quoter_completion, :follow_up, :update_details_attribute, :update_quote_param,
                :owners_update, :owner_contact_info_update]

  before_filter :require_crm_connection, :only => [:create, :index]

  #will move this autocomplete option once CarriersController is added and made the appropriate changes
  autocomplete :carrier, :name

  def leads
    if params[:mgr] == "true"
      @crm_cases = Crm::Case.get_cases_for_manager(current_user)
    else
      @crm_cases = Crm::Case.get_cases_for_user(current_user)
    end
    #chaining scope 'parse_to_scope' when params search
    if params[:q]
      @crm_cases = @crm_cases.parse_to_scope(params[:q], ['crm_connections.first_name', 'crm_connections.last_name'])
    end

    @crm_cases = @crm_cases.get_cases_for_connection_type('lead').uniq.paginate(:page => params[:page], :per_page => 10)

    respond_to do | format |
      format.js {
        render :layout => false
      }
      format.html{
        render :layout => "application"
      }
    end
  end

  def book_of_business
    if params[:mgr] == "true"
      @crm_cases = Crm::Case.get_cases_for_manager(current_user)
    else
      @crm_cases = Crm::Case.get_cases_for_user(current_user)
    end
    #chaining scope 'parse_to_scope' when params search
    if params[:q]
      @crm_cases = @crm_cases.parse_to_scope(params[:q], ['crm_connections.first_name', 'crm_connections.last_name'])
    end

    @crm_cases = @crm_cases.get_cases_for_connection_type('client').uniq.paginate(:page => params[:page], :per_page => 10)

    respond_to do | format |
      format.js {
        render :layout => false
      }
      format.html{
        render :layout => "application"
      }
    end
  end

  def prospects
    if params[:mgr] == "true"
      @crm_cases = Crm::Case.get_cases_for_manager(current_user)
    else
      @crm_cases = Crm::Case.get_cases_for_user(current_user)
    end
    #chaining scope 'parse_to_scope' when params search
    if params[:q]
      @crm_cases = @crm_cases.parse_to_scope(params[:q], ['crm_connections.first_name', 'crm_connections.last_name'])
    end

    @crm_cases = @crm_cases.get_cases_for_connection_type('prospect').uniq.paginate(:page => params[:page], :per_page => 10)

    respond_to do | format |
      format.js {
        render :layout => false
      }
      format.html{
        render :layout => "application"
      }
    end
  end

  def new
    @crm_case = Crm::Case.new()
  end

  def create
    @crm_case = @crm_connection.cases.build(params[:crm_case])
    @crm_case.assign_to_agent(current_user)
    @crm_case.active = true
    if @crm_case.save
      respond_to do |format|
        format.js {
          @crm_cases = @crm_connection.try(:cases).where(:active=>true)
          @container_to_be_replaced = params[:container_id]
          render :layout => false
        }
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-error').html('There is some problem in saving the records.');" }
        format.html {}
      end
    end
  end

  def update_details_attribute
    details = Quoting::Quote.find_by_id(params[:pk])
    if details && details.update_attribute(params['name'], params['value'])
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end

  def update_quote_param
    details = Quoting::Quote.find_by_id(params[:details_id])
    quote_param = details.quote_param_dyn
    if quote_param && quote_param.update_attribute(params['name'], params['value'])
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end

  def get_policy_types
    @policy_types = Crm::PolicyType.all
    render :json => @policy_types.map{|p| {'value'=> p.id, 'text'=> p.name}}
  end

  def details
    if @crm_case.quoted_details
      @quoted_details = @crm_case.quoted_details
    else
      @quoted_details = Quoting::Quote.create
      @crm_case.update_attribute(:quoted_details, @quoted_details)
    end

    if @crm_case.submitted_details
      @submitted_details = @crm_case.submitted_details
    else
      @submitted_details = Quoting::Quote.create
      @crm_case.update_attribute(:submitted_details, @submitted_details)
    end

    if @crm_case.approved_details
      @approved_details = @crm_case.approved_details
    else
      @approved_details = Quoting::Quote.create
      @crm_case.update_attribute(:approved_details, @approved_details)
    end

    respond_to do |format|
      format.js { render layout:false }
      format.html {}
    end
  end

  def destroy
    crm_cases_ids = params[:case_ids].to_s.split(",")
    crm_cases_ids.each do |crm_case_id|
      crm_case = Crm::Case.find_by_id(crm_case_id)
      if crm_case.editable?(current_user)
        crm_case.update_attribute(:active, false)
      end
    end
    respond_to do |format|
      format.js { render :text => ";$('#flash-container').html('Successfully Deleted');" }
      format.html {}
    end
  end

  def exam
    respond_to do |format|
      format.js {
        render :layout => false
      }
      format.html {}
    end
  end

  def exam_completion
    if @crm_case.exam_status == "Completed"
      render :inline => "<%= \"<i class='icon-check'></i>\".html_safe %>"
    else
      render :inline => "<%= \"<i class='icon-check-empty'></i>\".html_safe %>"
    end
  end

  def requirements
    @case_requirements = Crm::CaseRequirement.all

    respond_to do | format |
      format.js {}
      format.html{}
    end
  end
  
  def index
    @detail_tab=params[:case_detail]
    @crm_cases = @crm_connection.try(:cases).where(:active=>true) if @crm_connection.present?
    respond_to do | format |
      format.js {}
      format.html{
        render :layout => "connection_summary"
      }
    end
  end

  def owner
    @case = Crm::Case.find(params[:case_id])
    if @case.owner_id.blank?
      @owner = Crm::Owner.create(:case_id => params[:case_id])
      @case.owner_id = @owner.id
      @case.save
    else
      @owner = @case.owner
    end
    respond_to do |format|
      format.js {
        @container_to_be_replaced ||= container_to_be_used(params[:container_id])
      }
      format.html {}
    end
  end

  def owners_update
    @owner = Crm::Owner.find(params[:pk])
    if @owner.update_attribute(params['name'], params['value'])
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end

  def owner_contact_info_update
    @owner = Crm::Owner.find(params[:pk])
    if @owner.contact_info.new_record?
      contact_info = @owner.contact_info
      contact_info.save
      @owner.contact_info_id = contact_info.id
      @owner.save
    end
    if params['name'] == 'address'
      if @owner.contact_info.addresses.blank?
        @owner.contact_info.addresses.create(:value => params[:value])
      else
        @owner.contact_info.addresses.first.update_attribute('value', params[:value])
      end
    end
    if params['name'] == 'phone'
      if @owner.contact_info.phones.blank?
        @owner.contact_info.phones.create(:value => params[:value])
      else
        @owner.contact_info.phones.first.update_attribute('value', params[:value])
      end
    end
    if params['name'] == 'email'
      if @owner.contact_info.emails.blank?
        @owner.contact_info.emails.create(:value => params[:value])
      else
        @owner.contact_info.emails.first.update_attribute('value', params[:value])
      end
    end
    respond_to do |format|
      format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
      format.html {}
    end
  end

  def get_owner_beneficiary_type
    @boot = Crm::BeneficiaryOrOwnerType.all
    render :json => @boot.map{|p| {'value'=> p.id, 'text'=> p.name.try(:capitalize)}}
  end

  def quoter_completion
    if @crm_case.quoted_details
      render :inline => "<%= \"<i class='icon-check'></i>\".html_safe %>"
    else
      render :inline => "<%= \"<i class='icon-check-empty'></i>\".html_safe %>"
    end
  end

  def follow_up
    system_task = Crm::SystemTask.get_earliest_task(@crm_case).first
    follow_up_value = system_task.try(:label) ? system_task.try(:label) :
                      system_task.try(:status).try(:status_type).try(:name)
    render :text => follow_up_value
  end

  def update_agent
    crm_case_ids = params[:ids].to_s.split(",")
    crm_case_ids.each do |crm_case_id|
      crm_case = Crm::Case.find_by_id(crm_case_id)
      if crm_case.editable?(current_user)
        crm_case.update_attribute(:agent_id, params[:agent_id])
      end
    end
    respond_to do |format|
      format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
      format.html {}
    end
  end

  private

  def determine_container
    if params[:container]
      @container_to_be_replaced = params[:container]
      case @container_to_be_replaced
      when ['.tab-content', '#main-container']
        @detail_tab = params[:case_detail]
        @crm_cases  = @crm_connection.cases.where(active:true) if @crm_connection.present?
      when ['#case-pane-tab-content', '.tab-content', '#main-container']
      when '#main-container'
        return render 'connections/connection_summary'
      end
    else
      @container_to_be_replaced = '#case-pane-tab-content'
    end
  end

end
