class Marketing::MembershipsController < ApplicationController

  before_filter :require_login
  before_filter :require_super, :only => :index

  autocomplete :usage_user, :first_name, :class_name => "Usage::User"

  def index
    @marketing_memberships = Marketing::Membership.all

    respond_to do |format|
      format.js
    end
  end

  def show
    @marketing_membership = Marketing::Membership.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @marketing_membership = Marketing::Membership.new
    @ownerships = Ownership.all

    respond_to do |format|
      format.js
    end
  end

  def edit
    @marketing_membership = Marketing::Membership.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @marketing_membership = Marketing::Membership.new(params[:marketing_membership])

    respond_to do |format|
      if @marketing_membership.save
         @marketing_memberships = Marketing::Membership.all
        format.js
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @marketing_membership = Marketing::Membership.find(params[:id])
    @marketing_memberships = Marketing::Membership.all

    respond_to do |format|
      if @marketing_membership.update_attributes(params[:marketing_membership])
        format.js
        format.json { head :no_content }
      else
        format.js { render action: "edit" }
      end
    end
  end

  def destroy
    @marketing_membership = Marketing::Membership.find(params[:id])
    @marketing_membership.destroy
    @marketing_memberships = Marketing::Membership.all

    respond_to do |format|
      format.js
    end
  end

  def membership_templates
    templates=[]
    @marketing_membership = Marketing::Membership.find_by_owner_id(current_user.id)
    @crm_system_task_type = Crm::SystemTaskType.find_by_id(params[:task_type])
    crm_system_task_type_name = @crm_system_task_type.try(:name).try(:downcase)
    if @marketing_membership.present?
      if ["email", "email agent"].include?(crm_system_task_type_name)
        @marketing_membership.readable_email_templates.each do |template|
          templates << { :label => template.name, :id => template.id, :value => template.name}
        end
      elsif ["letter"].include?(crm_system_task_type_name)
        @marketing_membership.readable_letter_templates.each do |template|
          templates << { :label => template.name, :id => template.id, :value => template.name}
        end
      elsif ["phone dial", "phone broadcast", "sms", "sms agent"].include?(crm_system_task_type_name)
        @marketing_membership.readable_sms_templates.each do |template|
          templates << { :label => template.name, :id => template.id, :value => template.name}
        end
      end
    end
    @results = templates.sort!{ |a,b| a[:value] <=> b [:value] }.collect do |x|
      x if x[:value].to_s.include? params[:term]
    end
    render :json => @results.compact.to_json
  end
end
