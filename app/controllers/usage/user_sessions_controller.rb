class Usage::UserSessionsController < ApplicationController

  def new
    @user_session = Usage::UserSession.new
  end
  
  def create
    @user_session = Usage::UserSession.new(params[:usage_user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = Usage::UserSession.find
    unless session[:ostensible_user_id].blank?
      redirect_to 'usage_users_end_impersonate'
    end
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
  
end
