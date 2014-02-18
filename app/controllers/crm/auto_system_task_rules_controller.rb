class Crm::AutoSystemTaskRulesController < ApplicationController
  before_filter :require_login

  def new
    status_type = Crm::StatusType.find(params[:id])
    @roles = Usage::Role.all
    @task_types = Crm::SystemTaskType.all
    @auto_system_task_rules = status_type.auto_system_task_rules.new
  end

  def index
    status_type = Crm::StatusType.find(params[:id])
    @auto_system_task_rules = status_type.auto_system_task_rules
  end

  def create
    @crm_auto_system_task_rule = Crm::AutoSystemTaskRule.new(params[:crm_auto_system_task_rule])
    if @crm_auto_system_task_rule.save
      status_type = @crm_auto_system_task_rule.status_type
      params[:id] ||= status_type.id
      @auto_system_task_rules = status_type.auto_system_task_rules
      render :action => "index"
    else

    end
  end

  def destroy
    @crm_auto_system_task_rule = Crm::AutoSystemTaskRule.find_by_id(params[:id])
    @crm_auto_system_task_rule.destroy
  end

  def edit
    @crm_auto_system_task_rule = Crm::AutoSystemTaskRule.find(params[:id])
  end

  def update
    @crm_auto_system_task_rule = Crm::AutoSystemTaskRule.find(params[:id])
    if @crm_auto_system_task_rule.update_attributes(params[:crm_auto_system_task_rule])
      flash[:notice] = 'Auto system task rule was successfully updated.'
      render :text => "ok"
    else
      render :action => 'edit'
    end
  end
end
