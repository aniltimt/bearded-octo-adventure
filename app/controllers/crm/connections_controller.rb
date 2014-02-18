class Crm::ConnectionsController < Crm::CrmBaseController

  before_filter :require_crm_connection, :only => [:connection_summary, :health_completion, :health,
    :personal_completion, :personal, :connection_tags, :destroy_connection_tag, :show, :edit,
    :update, :add_spouse, :financial, :tracking]

  autocomplete :connections, :first_name, :class_name => 'Crm::Connection',
    :display_value => :full_name_with_address, :full => true

  respond_to :html, :js

  def index
    if params[:mgr] == "true"
      @crm_connections = Crm::Connection.editables(current_user)
    else
      @crm_connections = Crm::Connection.where(:agent_id => current_user.id)
    end

    #chaining scope 'parse_to_scope' when params for search
    if params[:q]
      @crm_connections = @crm_connections.parse_to_scope(params[:q], ['crm_connections.first_name', 'crm_connections.last_name'])
    end

    @crm_connections = @crm_connections.where(:active => true).uniq.paginate(:page => params[:page], :per_page => 10)

    respond_to do | format |
      format.js {
        render :layout => false
      }
      format.html{
        render :layout => "application"
      }
    end
  end

  alias_method :contacts, :index

  def connection_summary
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def personal

    respond_to do |format|
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html{
        render :layout => 'connection_summary'
      }
    end
  end

  alias_method :show, :personal

  def create
    @crm_connection = Crm::Connection.new(params[:crm_connection])
    @crm_connection.active = true
    @crm_connection.agent_id = current_user.id
    @crm_connection.profile_id = current_user.current_profile(cookies).try(:id)

    if @crm_connection.contact_info.blank?
      contact_info = ContactInfo.new()
      2.times { contact_info.addresses.build }
      contact_info.save
      @crm_connection.contact_info_id = contact_info.id
    end

    if @crm_connection.save
      if @crm_connection.contact_info.try(:addresses).blank?
        contact_info = @crm_connection.contact_info
        2.times { contact_info.addresses.build }
        contact_info.save
      end
      @crm_connection.add_tags(params[:tags]) if params[:tags].present?
      redirect_to connection_summary_crm_connections_path(:connection_id => @crm_connection.id)
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('There is some problem in saving the records.');" }
        format.html {}
      end
    end
  end

  def destroy
    crm_connection_ids = params[:connection_ids].to_s.split(",")
    crm_connection_ids.each do |crm_connection_id|
      crm_connection = Crm::Connection.find_by_id(crm_connection_id)
      if crm_connection.editable?(current_user)
        crm_connection.update_attribute(:active, false)
      end
    end
    respond_to do |format|
      format.js { render :text => ";$('#flash-container').html('Successfully Deleted');" }
      format.html {}
    end
  end

  def edit
    render :layout => false
  end

  def update
    if @crm_connection && @crm_connection.update_attribute(params['name'], params['value'])
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

  def health
    @health = @crm_connection.health_info
    respond_with @health
  end

  def health_completion
    if @crm_connection.health_info.try(:complete?)
      render :inline => "<%= \"<i class='icon-check'></i>\".html_safe %>"
    else
      render :inline => "<%= \"<i class='icon-check-empty'></i>\".html_safe %>"
    end
  end

  def personal_completion
    is_fields_present = true
    ['first_name', 'last_name', 'middle_name', 'marital_status_id', 'contact_info_id',
      'dln', 'ssn', 'citizenship_id', 'birth_country', 'birth_state_id',
      'note'].each do |field|
      if @crm_connection[field].blank? then
        is_fields_present = false
        break
      end
    end

    is_fields_present = is_fields_present && @crm_connection.address.present? && @crm_connection.email.present? && @crm_connection.phone.present?

    if is_fields_present
      render :inline => "<%= \"<i class='icon-check'></i>\".html_safe %>"
    else
      render :inline => "<%= \"<i class='icon-check-empty'></i>\".html_safe %>"
    end
  end

  def prospects
    if params[:mgr] == "true"
      @crm_connections = current_user.editable_connections
    else
      @crm_connections = Crm::Connection.where(:agent_id => current_user.id)
    end
    @crm_connections = @crm_connections.connections_by_connection_type('prospect')

    #chaining scope 'parse_to_scope' when params for search
    if params[:q]
      @crm_connections = @crm_connections.parse_to_scope(params[:q], ['crm_connections.first_name', 'crm_connections.last_name'])
    end

    @crm_connections = @crm_connections.where(:active => true).uniq.paginate(:page => params[:page], :per_page => 10)

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
  end

  def search
  end

  def connection_tags
    @connection_tags = @crm_connection.tags
    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def destroy_connection_tag
    if @crm_connection.editable?(current_user)
      @connection_tag = @crm_connection.tags.find_by_id(params[:tag_id])
      @connection_tag.try(:delete)
      @connection_tags = @crm_connection.tags
      respond_to do | format |
        format.js {render :layout => false}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('You don\'t have permission to delete tags');", :status => 401 }
        format.html {}
      end
    end
  end

  def get_marrital_statuses
    @marrital_statuses = MaritalStatus.all
    render :json => @marrital_statuses.map{|p| {'value'=> p.id, 'text'=> p.name}}
  end

  def get_citizenships
    @citizenships = Crm::Citizenship.all
    render :json => @citizenships.map{|p| {'value'=> p.id, 'text'=> p.name}}
  end

  def update_agent
    crm_connection_ids = params[:ids].to_s.split(",")
    crm_connection_ids.each do |crm_connection_id|
      crm_connection = Crm::Connection.find_by_id(crm_connection_id)
      if crm_connection.editable?(current_user)
        crm_connection.update_attribute(:agent_id, params[:agent_id])
      end
    end
    respond_to do |format|
      format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
      format.html {}
    end
  end

  def add_spouse
    render :layout => false
  end

  def get_autocomplete_items(parameters)
    super(parameters)
    items = Crm::Connection.search_full_name(params[:term])
  end

  def financial
    if @crm_connection.financial_info_id.blank?
      @crm_financial_info = Crm::FinancialInfo.create
      @crm_connection.financial_info_id = @crm_financial_info.id
      @crm_connection.save
    else
      @crm_financial_info =  @crm_connection.financial_info
    end
    if @crm_connection.contact_info_id.blank?
      @crm_contact_info = Crm::ContactInfo.create
      @crm_connection.contact_info_id = @crm_contact_info.id
      @crm_connection.save
    end
    @crm_cases = Crm::Case.find(:all, :conditions => ["connection_id = '#{@crm_connection.id}'"])
    @crm_case = Crm::Case.new

    respond_to do |format|
      format.js {
        render :layout => false
      }
      format.html{
        render :layout => 'connection_summary'
      }
    end
  end

  def financial_info_update
    financial_info = Crm::FinancialInfo.find_by_id(params[:pk])

    if financial_info && financial_info.update_attribute(params['name'], params['value'])
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

  def connection_info_update
    connection_info = Crm::Connection.find_by_financial_info_id(params[:pk])

    if connection_info && connection_info.update_attribute(params['name'], params['value'])
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

  def contact_info_update
    @crm_connection = Crm::Connection.find_by_id(params[:pk])

    if @crm_connection.contact_info && @crm_connection.contact_info.update_attribute(params['name'], params['value'])
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

  def new_connection_spouse
    @crm_connection = Crm::Connection.find_by_id(params[:connection_id])
    @new_connection  = Crm::Connection.new(:title => params[:title], :first_name => params[:first_name], :last_name => params[:last_name], :spouse_id => @crm_connection.id, :agent_id => current_user.id )
    @new_connection.save
    if @crm_connection && @crm_connection.update_attribute('spouse_id', @new_connection.id)
      respond_to do |format|
          format.js { render :layout => false }
          format.html {}
      end
    end
  end

  def tracking
    @tags = @crm_connection.tags
  end

  def get_connection_types
    @connection_types = Crm::ConnectionType.all
    render :json => @connection_types.map{|p| {'value'=> p.id, 'text'=> p.name}}
  end
end

