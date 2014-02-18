class Usage::PasswordResetsController < ApplicationController

  def new
  end

  def create
    email_address = EmailAddress.find_by_value(params[:email])
    if email_address
      contact_info = email_address.contact_info
      if contact_info
        user = contact_info.user
        user.send_password_reset(params[:email]) if user
      end
    end
    flash[:notice] = "Email sent with reset password instructions."
    redirect_to root_url
  end

  def edit
    @user = Usage::User.find_by_perishable_token!(params[:id])
  end

  def update
    @user = Usage::User.find_by_perishable_token!(params[:id])
    @user.password = params[:usage_user][:password]
    @user.password_confirmation = params[:usage_user][:password_confirmation]
    if @user.password.blank? || @user.password_confirmation.blank?
      flash[:notice] = "Please enter password and password confirmation"
      render :edit and return
    end
    if  @user.save
      flash[:notice] = "Password updated successfully."
      redirect_to root_url 
    else
      render :edit
    end
  end

end
