class Crm::StatusesController < Crm::CrmBaseController

  before_filter :require_crm_case, :only => [:create]
  before_filter :require_crm_status, :only => [:show, :update]

  def create
    @crm_case.set_status(params[:status_type_id].to_i)
    @crm_case.status.update_attribute(:created_by, current_user.id)
    render :json => {'status_id' => @crm_case.status_id}
  end

  def show
    @crm_system_tasks = @crm_status && @crm_status.system_tasks.order("due_at") || []
    @case_id = @crm_status ? @crm_status.case_id : params[:case_id]
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def update
    respond_to do |format|
      if @crm_status.update_attributes(params[:crm_status])
        format.js { render :text => ";$('#flash-notice').html('Successfully updated');" }
        format.html {}
      else
        format.js { render :text => ";$('#flash-notice').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end

private

  def require_crm_status
    @crm_status = if params[:case_id].present?
                    @crm_case = Crm::Case.find_by_id(params[:case_id])
                    @crm_case.try(:status)
                  else
                    Crm::Status.find_by_id(params[:id])
                  end
    if @crm_status
					unless @crm_status.try(:viewable?, current_user)
							permission_denied
					end
    end
  end
end
