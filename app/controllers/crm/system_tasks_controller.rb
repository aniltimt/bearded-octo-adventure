class Crm::SystemTasksController < Crm::CrmBaseController

  before_filter :require_crm_connection, :only => [:cases_current_status_system_tasks]
  before_filter :is_crm_status_editable, :only => [:new, :create, :update, :edit, :destroy, :show]

  def show
    crm_system_task = @crm_status.system_tasks.find_by_id(params[:id])
    unless crm_system_task.blank?
      @template = crm_system_task.get_template
      unless @template.blank?
        @body = @template.apply(crm_system_task.crm_connection.agent, crm_system_task.crm_connection.profile, nil, {'connection' => crm_system_task.crm_connection, 'case' => crm_system_task.status.case})
      end
    end
    respond_to do |format|
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html {}
    end
  end

  def new
    @crm_system_task = Crm::SystemTask.new()
    respond_to do |format|
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html {}
    end
  end

  def create
    @crm_system_task = Crm::SystemTask.new(params['crm_system_task'])
    @crm_system_task.status_id = @crm_status.id
    @crm_system_task.created_by = current_user.id
    respond_to do |format|
      if @crm_system_task.save
        format.js { render :text => ";$('#flash-notice').html('Successfully Created');" }
        format.html {}
      else
        format.js { render :text => ";$('#flash-notice').html('Not Created');", :status => 203 }
        format.html {}
      end
    end
  end

  def edit
    @crm_system_task = @crm_status.system_tasks.find_by_id(params[:id])
  end

  def update
    @crm_system_task = @crm_status.system_tasks.find_by_id(params[:id])
    @crm_system_task.curr_user = current_user
    respond_to do |format|
      if @crm_system_task && @crm_system_task.update_attributes(params['crm_system_task'])
        format.js { render :text => ";$('#flash-notice').html('Successfully updated');" }
        format.html {}
      else
        format.js { render :text => ";$('#flash-notice').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end

  def destroy
    @crm_system_task = @crm_status.system_tasks.find_by_id(params[:id])
    respond_to do |format|
      if @crm_system_task && @crm_system_task.destroy
        format.js { render :text => ";$('#flash-notice').html('Successfully deleted');" }
        format.html {}
      else
        format.js { render :text => ";$('#flash-notice').html('Not able to delete');", :status => 203 }
        format.html {}
      end
    end
  end

  def dashboard
    @crm_system_tasks = Crm::SystemTask.get_user_active_tasks(current_user)
    incomplete_tasks = @crm_system_tasks.incomplete_tasks
    @incomplete_tasks = incomplete_tasks.incomplete_tasks.paginate(:page => params[:incomplete_tasks_page], :per_page => 10)

    respond_to do | format |
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html{}
    end
  end

  def cases_current_status_system_tasks
    @crm_system_tasks = []

    @crm_connection.cases.each do |crm_case|
      if crm_case.status.present? && crm_case.status.system_tasks.present?
        @crm_system_tasks += crm_case.status.system_tasks.where("completed_at is null")
      end
    end
    respond_to do | format |
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
      format.html{}
    end
  end

  def sidebar
    @crm_system_tasks = Crm::SystemTask.get_user_active_tasks(current_user)
    incomplete_tasks = @crm_system_tasks.incomplete_tasks
    @incomplete_tasks = incomplete_tasks.paginate(:page => params[:page], :per_page => 10)
    respond_to do | format |
      format.js {
        render :layout => false
      }
    end
  end

private

  def is_crm_status_editable
    if params[:case_id].present?
      @crm_case = Crm::Case.find_by_id(params[:case_id])
      @crm_status = @crm_case.try(:status)
    else
      @crm_status = Crm::Status.find_by_id(params[:status_id])
    end

    unless @crm_status.try(:editable?, current_user)
      return render 'home/permission_denied', :layout => false, :status => 401
    end
  end

end
