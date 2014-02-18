class Usage::ProfilesController < ApplicationController

  before_filter :require_login, :get_profile_owner
  before_filter :authorize_user, :except => [:select]
  # Sets the :profile_id value in the current_user's session
  
  autocomplete :users, :first_name, :class_name => 'Usage::User',
    :display_value => :full_name, :full => true

  
  def select
    session[:profile_id] = params[:id]
    render text: 'success'
  end
  
  def new
    @contact_info = ContactInfo.new
    @contact_info.build_profile
    @contact_info.emails.build
    @contact_info.addresses.build
    @contact_info.phones.build
    @title = 'New Profile'
  end
  
  def create 
    if @usage_user
      params[:contact_info][:profile_attributes][:owner_id] = @usage_user.id
      @contact_info = ContactInfo.new(params[:contact_info])
      respond_to do |format|
        if @contact_info.save
          Usage::ProfilesUser.create(:profile_id => @contact_info.reload.profile.id, :user_id => @usage_user.id )
          @title = 'Profiles List'
          format.js {
          }
          format.html { redirect_to :action => :index }
        else
          @title = 'New Profile'
          format.js {}
          format.html { render :action => :index }
        end
      end
    end
  end
  
  def edit
    @profile = Usage::Profile.find(params[:id])
    if @profile
      @contact_info = @profile.contact_info
      build_association_fields
      @title = 'Edit Profile'
    end
  end
  
  def update
    @profile = Usage::Profile.find(params[:id])
    if @usage_user
      @contact_info = @profile.contact_info
      respond_to do |format|
        if @contact_info && @contact_info.update_attributes(params[:contact_info])
          @title = 'Profiles List'
          format.js { 
          }
          format.html { redirect_to :action => :index }
        else
          @title = 'Edit Profile'
          format.js { }
          format.html { }
        end
      end
    end
  end
  
  def index
    @profiles = Usage::Profile.editables( @usage_user )
    @title = 'Profiles List'
  end
  
  def destroy
    @profile = Usage::Profile.find(params[:id])
    @profiles = @usage_user.profiles
    respond_to do |format|
      @contact_info = @profile.contact_info
      if @contact_info
        @title = 'Profiles List'
        if @contact_info.destroy
          format.js {}
          format.html {
            flash[:notice] = "Deleted Successfully."
            redirect_to :action => :index
          }
        else
          format.js { }
          format.html { 
            flash[:error] = "Not Deleted."
            redirect_to :action => :index
          }
        end
      end
    end
  end
  
  def assign_profile
    @profile = Usage::Profile.find(params[:profile_id])
    @contact_info = @profile.contact_info
    build_association_fields
    @title = 'Edit Profile'
    respond_to do |format|
      if @profile && Usage::ProfilesUser.where(:profile_id => @profile.id, :user_id => params[:user_id] ).blank?
        if @assigned = Usage::ProfilesUser.create(:profile_id => @profile.id, :user_id => params[:user_id] )
          format.js {}
          format.html {
            flash[:notice] = "Assigned Successfully."
            redirect_to :action => :index
          }
        else
          format.js { }
          format.html { 
            flash[:error] = "Not Assigned."
            redirect_to :action => :index
          }
        end
      else
        format.js { }
        format.html { 
          flash[:error] = "Already Assigned."
          redirect_to :action => :index
        }
      end
    end
  end

  def remove_profile
    @profile = Usage::Profile.find(params[:profile_id])
    @contact_info = @profile.contact_info
    @user = Usage::User.find(params[:user_id])
    build_association_fields
    @title = 'Edit Profile'
    respond_to do |format|
      if current_user.can_edit_user?(@user) && @profile.users.delete(@user) && current_user != @user
        @removed = true
        format.js { }
        format.html {
          flash[:notice] = "Successfully Removed."
          redirect_to :action => :index
        }
      else
        format.js { }
        format.html { 
          flash[:error] = "Not Removed."
          redirect_to :action => :index
        }
      end
    end
  end
  
  private
  
  def authorize_user
    unless params[:owner_id].blank?
      unless current_user.role.super?
        redirect_to root_path, flash: {error: "You need admin privileges to continue"}
      end
    end
  end
  
  def get_profile_owner
    if !params[:owner_id].blank? && current_user.role.super?
      @usage_user = Usage::User.find(params[:owner_id])
    else
      @usage_user = current_user
    end
  end
  
  def build_association_fields
    @contact_info.emails.build if @contact_info.emails.blank?
    @contact_info.addresses.build if @contact_info.addresses.blank?
    @contact_info.phones.build if @contact_info.phones.blank?
  end
  
end
