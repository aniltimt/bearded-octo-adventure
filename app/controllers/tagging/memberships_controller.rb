class Tagging::MembershipsController < ApplicationController

  before_filter :require_super, :only => :index
  autocomplete :usage_user, :first_name, :class_name => "Usage::User"
  
  def index
    @tagging_memberships = Tagging::Membership.all

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end
  
  def show
    @tagging_membership = Tagging::Membership.find(params[:id])

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end

  def new
    @tagging_membership = Tagging::Membership.new
    @ownerships = Ownership.all
     
    respond_to do |format|
      format.js {render :layout => false} 
    end
  end
  
  def edit
    @tagging_membership = Tagging::Membership.find(params[:id])
    
    respond_to do |format|
      format.js {render :layout => false} 
    end
  end
  
  def create
    @tagging_membership = Tagging::Membership.new(params[:tagging_membership])
    @tagging_membership.save

    respond_to do |format|
      if @tagging_membership.save
         @tagging_membership = Tagging::Membership.new
         @ownerships = Ownership.all
        format.js {render :layout => false} 
      else
        format.js { render action: "new" }
      end
    end
  end

  def update
    @tagging_membership = Tagging::Membership.find(params[:id])
    @tagging_memberships = Tagging::Membership.all
    
    respond_to do |format|
      if @tagging_membership.update_attributes(params[:tagging_membership])
         @tagging_membership = Tagging::Membership.new
        format.js {render :layout => false} 
      else
        format.js { render action: "edit" }
      end
    end
  end
  
  def destroy
    @tagging_membership = Tagging::Membership.find(params[:id])
    @tagging_membership.destroy
    @tagging_memberships = Tagging::Membership.all

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end
end
