class Usage::UsersController < ApplicationController

  before_filter :require_login
  before_filter :require_usage_user, :only => ['personal', 'tasks', 'completed_tasks', 'incomplete_tasks']
  

  autocomplete :users, :first_name, :class_name => 'Usage::User',
    :display_value => :full_name, :full => true
    
  def new
    if params[:user_id].present?
      @usage_user = Usage::User.find_by_id(params[:user_id])
    else
      @usage_user = current_user
    end

    if current_user.can_edit_user?(@usage_user) && @usage_user.try(:can_have_children?)
      @contact_info = ContactInfo.new
      @contact_info.build_user
      2.times { @contact_info.emails.build }
      2.times { @contact_info.addresses.build }
      3.times { @contact_info.phones.build }
      respond_to do |format|
        format.js { render :layout => false}
        format.html { render :layout => true }
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-error').html('You do not have permission to create user');", :status => 401 }
        format.html { redirect_to :root}
      end
    end
  end

  def personal
    respond_to do |format|
      format.js { render :layout => false}
      format.html { render :layout => true }
    end
  end

  def create
    @usage_user = Usage::User.find_by_id(params["contact_info"]["user_attributes"]["parent_id"])
    if current_user.can_edit_user?(@usage_user) && @usage_user.try(:can_have_children?)
      @contact_info = ContactInfo.new(params[:contact_info])
      if @contact_info.save
        flash[:notice] = "Account created."
        redirect_to :action => "personal", :user_id => @contact_info.user.id
      else
        render :action => 'new'
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-error').html('You do not have permission to create user');", :status => 401 }
        format.html {
          flash[:error] = "You don't have permission to create user"
          redirect_to :root
        }
      end
    end
  end

  def update_attribute
    if current_user.update_attribute(params['name'], params['value'])
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not updated successfully');", :status => 203 }
        format.html {}
      end
    end
  end

  def update_agent_field_set
    @usr = Usage::User.find(params[:id])
    respond_to do |format|
      if @usr.agent_field_set
        if @usr.agent_field_set.update_attributes(params[:agent_field_set])
          format.js
          format.html {}
        else
          format.js { render :text => ";$('#flash-container').html('Not updated successfully');", :status => 203 }
          format.html {}
        end
      end
    end
  end

  def update_password
    @usage_user = Usage::User.find_by_id(params[:id])
    if current_user.can_edit_user?(@usage_user)
      if params['usage_user']['password'].present? && params['usage_user']['password'] == params['usage_user']['password_confirmation']
        @usage_user.update_attributes(params['usage_user'])
        respond_to do |format|
          format.js { render :text => ";$('#flash-notice').html('Successfully updated.');" }
          format.html {}
        end
      else
        respond_to do |format|
          format.js { render :text => ";$('#flash-error').html('Password not matched.');", :status => 422 }
          format.html {}
        end
      end
    else
      permission_denied
    end
  end

  def update
    @usage_user = Usage::User.find_by_id(params[:id])
    if current_user.can_edit_user?(@usage_user)
      if @usage_user.update_attribute(params['name'], params[:value])
        respond_to do |format|
          format.js { render :text => ";$('#flash-notice').html('Successfully updated.');" }
          format.html {}
        end
      else
        respond_to do |format|
          format.js { render :text => ";$('#flash-error').html('Not updated successfully.');", :status => 203 }
          format.html {}
        end
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-error').html('You don\'t have permission to access it.');", :status => 401}
        format.html {}
      end
    end
  end

  def get_autocomplete_items(parameters)
    super(parameters)
    items = Usage::User.search_full_name(params[:term])
  end

  def assign_agent
    render :layout => false
  end

  def permissions
    @container_to_be_replaced = container_to_be_used(params[:container_id])

    if params[:user_id].present?
      @usage_user = Usage::User.find_by_id(params[:user_id])
      @childrens = @usage_user.children.editables(current_user).uniq
      @box_id = params["box"] == "2" ? "3" : (params["box"] == "3" ? "4" : "2")
      if params[:box] == "1"
        @users_for_select = Usage::User.find_ancestry_between_users(current_user, @usage_user)
      end
    else
      @usage_user = current_user
      @childrens = current_user.children.editables(current_user).uniq
      @box_id = "2"
      @users_for_select = [current_user]
    end

    respond_to do |format|
      format.js { render :layout => false}
      format.html { render :layout => true }
    end
  end

  alias_method :index, :permissions

  def search_users
    @box_id = params[:box]
    search_strings = params[:q].to_s.split(",")
    @childrens = Usage::User.search_by_first_or_last_name(search_strings).viewables(current_user).uniq
  end
  
  alias_method :search_agency_users, :search_users
  
  def update_permissions
    ids = params['ids'].to_s.split(",")

    if ids.present?
      @users = Usage::User.where("id in (?)", ids).editables(current_user)
      fields_value_hash = {}

      if params['siblings'].present? && Usage::User::PRIVILAGE_SIBLINGS[params['siblings']]
        fields_value_hash = fields_value_hash.merge(Usage::User::PRIVILAGE_SIBLINGS[params['siblings']])
      end

      if params['nephews'].present? && Usage::User::PRIVILAGE_NEPHEWS[params['nephews']]
        fields_value_hash = fields_value_hash.merge(Usage::User::PRIVILAGE_NEPHEWS[params['nephews']])
      end

      if params['descendents'].present? && Usage::User::PRIVILAGE_DESCENDENTS[params['descendents']]
        fields_value_hash = fields_value_hash.merge(Usage::User::PRIVILAGE_DESCENDENTS[params['descendents']])
      end

      if params['siblings_resources'].present? && Usage::User::PRIVILAGE_SIBLINGS_RESOURCES[params['siblings_resources']]
        fields_value_hash = fields_value_hash.merge(Usage::User::PRIVILAGE_SIBLINGS_RESOURCES[params['siblings_resources']])
      end

      if params['nephews_resources'].present? && Usage::User::PRIVILAGE_NEPHEWS_RESOURCES[params['nephews_resources']]
        fields_value_hash = fields_value_hash.merge(Usage::User::PRIVILAGE_NEPHEWS_RESOURCES[params['nephews_resources']])
      end

      if params['descendents_resources'].present? && Usage::User::PRIVILAGE_DESCENDENTS_RESOURCES[params['descendents_resources']]
        fields_value_hash = fields_value_hash.merge(Usage::User::PRIVILAGE_DESCENDENTS_RESOURCES[params['descendents_resources']])
      end

      if params['can_edit_self'].present?
        fields_value_hash['can_edit_self'] = true
      end

      if params['assign_role'].present? && params['user_role'].present?
        fields_value_hash['role_id'] = params['user_role']['role_id']
      end

      @users.update_all(fields_value_hash)

      respond_to do |format|
        format.js { render :text => ";$('#flash-notice').html('Update permissions successfully');"}
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-error').html('You don\'t select any user.');"}
        format.html {}
      end
    end
  end

  def lead_distribution_rules
    @children = current_user.children
  end

  def assign_profile
    assignes = []
    @user = Usage::User.find(params[:user_id])
    ids = params['profile_ids'].to_s.split(",")
    @profiles = Usage::Profile.where(:id => ids)
    respond_to do |format|
      if @user && !ids.blank?
        @profiles.each do |profile|
          assig = Usage::ProfilesUser.create(:profile_id => profile.id, :user_id => params[:user_id] ) if Usage::ProfilesUser.where(:profile_id => profile.id, :user_id => params[:user_id] ).blank?
          assignes << assignes unless assig.blank?
        end
        @msg = assignes.blank? ? "Already assigned all profiles to selected user." : "Successfully Assigned."
        format.js { }
        format.html {}
      else
        @msg = "Something went wrong..."
        format.js { }
        format.html {}
      end
    end
  end

  def assign_profile_model
    render :layout => false
  end

  def l_and_c
    params[:id] ||= params[:user_id]
    @usage_user = Usage::User.find_by_id(params[:id])
    
    if @usage_user.agent_field_set.blank?
      @agent_field_set = Usage::AgentFieldSet.create
      @usage_user.update_attributes(:agent_field_set_id => @agent_field_set.id )
      if @usage_user.agent_field_set.aml.blank? 
        @aml = Usage::Aml.create
        @agent_field_set.update_attributes(:aml_id => @aml.id )
        @aml_vendor = Usage::AmlVendor.create
        @aml.update_attributes(:vendor_id => @aml_vendor.id )
      end
    else
      if @usage_user.agent_field_set.aml.blank? 
        @aml = Usage::Aml.create
        @usage_user.agent_field_set.update_attributes(:aml_id => @aml.id )
        @aml_vendor = Usage::AmlVendor.create
        @aml.update_attributes(:vendor_id => @aml_vendor.id )
      end
      @aml = @usage_user.agent_field_set.aml
      @aml_vendor = Usage::AmlVendor.find(@aml.vendor_id)     
    end
    @states = []
    @states << @usage_user.agent_field_set.contracts.collect {|r| r.state}.collect {|a| a.name}
    @states << @usage_user.agent_field_set.licenses.collect {|r| r.state}.collect {|a| a.name}
    if @states
    @states = @states.flatten
    @states = @states.uniq
    end

    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def update_usage_license
    usage_license = Usage::License.find(params[:pk])

    if usage_license && usage_license.update_attribute(params['name'], params['value'])
      today_date = Date.today
      if usage_license.effective_date > today_date
        usage_license.update_attribute('expiration_warning_sent', 'false')
      else
        usage_license.update_attribute('expiration_warning_sent', 'true')
      end
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');"}
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end

  def update_aml_vendor
      if params["name"] == "name"
        @aml_vendor = Usage::AmlVendor.find(params[:pk])
        @aml_vendor.name = params[:value]
        @aml_vendor.save
      else
        @usage_user = Usage::User.find_by_id(params[:pk])
        @aml = @usage_user.agent_field_set.aml.update_attribute('completion', params[:value])
      end
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      end
    end

  def tasks
    respond_to do | format |
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html{}
    end
  end

  def incomplete_tasks
    @crm_system_tasks = Crm::SystemTask.get_user_active_tasks(@usage_user)
    incomplete_tasks = @crm_system_tasks.incomplete_tasks

    if params[:q].present?
      incomplete_tasks = incomplete_tasks.search_system_tasks(params[:q])
    end

    if params["user-incomplete-tasks-date-range-field"].present?
      incomplete_tasks = incomplete_tasks.where(:created_at => Date.parse(params[:incomplete_from_date])..Date.parse(params[:incomplete_to_date]))
    end

    @incomplete_tasks = incomplete_tasks.paginate(:page => params[:incomplete_tasks_page], :per_page => 10)

    respond_to do | format |
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html{}
    end
  end

  def completed_tasks
    @crm_system_tasks = Crm::SystemTask.get_user_active_tasks(@usage_user)
    completed_tasks = @crm_system_tasks.completed_tasks

    if params[:q].present?
      completed_tasks = completed_tasks.search_system_tasks(params[:q])
    end

    if params["user-completed-tasks-date-range-field"].present?
      completed_tasks = completed_tasks.where(:created_at => Date.parse(params[:completed_from_date])..Date.parse(params[:completed_to_date]))
    end

    @completed_tasks = completed_tasks.paginate(:page => params[:completed_tasks_page], :per_page => 10)

    respond_to do | format |
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html{}
    end
  end

  def memberships
    @user_memberships = [Marketing::Membership, Reporting::Membership, Tagging::Membership]

    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def impersonate
    if current_user.can_edit_user?(Usage::User.find(params[:id]))
      session[:ostensible_user_id] = params[:id]
      return redirect_to :root
    else
      respond_to do |format|
        format.html {
          flash[:error] = "You do not have permission to access it"
            return redirect_to :root
          }
      end
    end
    redirect_to :root
  end

  def end_impersonate
    session.delete(:ostensible_user_id)
    redirect_to :root
  end


  private

  def require_usage_user
    if params[:user_id].present?
      @usage_user = Usage::User.find_by_id(params[:user_id])
    end

    unless (@usage_user && current_user.try(:can_view_user?, @usage_user))
      respond_to do |format|
        format.js {render :template => "home/permission_denied", :status=>401}
        format.html {
          flash[:error] = "You do not have permission to access it"
          return redirect_to :root
        }
      end
    end
  end
end
