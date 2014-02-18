class Reporting::MembershipsController < ApplicationController
  autocomplete :usage_user, :first_name, :class_name => "Usage::User"
  before_filter :require_super, :only => :index
  def index
    @reporting_memberships = Reporting::Membership.all

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def show
    @reporting_membership = Reporting::Membership.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @reporting_membership = Reporting::Membership.new

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def edit
    @reporting_membership = Reporting::Membership.find(params[:id])

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def create
    @reporting_membership = Reporting::Membership.new(params[:reporting_membership])
    @reporting_membership.save
    @reporting_memberships = Reporting::Membership.all

    respond_to do |format|
      if @reporting_membership.save
        format.js {render :layout => false}
      else
        format.js { render action: "new" }
      end
    end
  end

  def update
    @reporting_membership = Reporting::Membership.find(params[:id])
    @reporting_memberships = Reporting::Membership.all

    respond_to do |format|
      if @reporting_membership.update_attributes(params[:reporting_membership])
        format.js {render :layout => false}
      else
        format.js { render action: "edit" }
      end
    end
  end

  def destroy
    @reporting_membership = Reporting::Membership.find(params[:id])
    @reporting_membership.destroy
    @reporting_memberships = Reporting::Membership.all

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
end
