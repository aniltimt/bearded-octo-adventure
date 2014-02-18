class Marketing::AutoTaskRulesController < ApplicationController
  
  autocomplete :marketing_campaigns, :name, :class_name => "Marketing::Campaign"
  autocomplete :auto_system_task_rules, :name, :class_name => "Crm::AutoSystemTaskRule"
  def index
    @marketing_auto_task_rules = Marketing::AutoTaskRule.order("id DESC")

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end

  def new
    @marketing_auto_task_rule = Marketing::AutoTaskRule.new

    respond_to do |format|
      format.js
    end
  end

  def edit
    @marketing_auto_task_rule = Marketing::AutoTaskRule.find(params[:id])
    
    respond_to do | format |  
      format.js {render :layout => false}  
    end
  end

  def create
    @marketing_auto_task_rule = Marketing::AutoTaskRule.new(params[:marketing_auto_task_rule])

    respond_to do |format|
      if @marketing_auto_task_rule.save
         @marketing_auto_task_rules = Marketing::AutoTaskRule.order("id DESC")
        format.js {render action: "index" } 
      else
        format.js { render action: "new" }
      end
    end
  end

  def update
    @marketing_auto_task_rule = Marketing::AutoTaskRule.find(params[:id])

    respond_to do |format|
      if @marketing_auto_task_rule.update_attributes(params[:marketing_auto_task_rule])
         @marketing_auto_task_rules = Marketing::AutoTaskRule.order("id DESC")
        format.js {render :layout => false}
      else
        format.js { render action: "edit" }
      end
    end
  end

  def destroy
    @marketing_auto_task_rule = Marketing::AutoTaskRule.find(params[:id])
    @marketing_auto_task_rule.destroy
    @marketing_auto_task_rules = Marketing::AutoTaskRule.order("id DESC")

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
end
