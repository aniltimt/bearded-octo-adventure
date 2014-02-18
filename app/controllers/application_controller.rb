class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def container_to_be_used(container)
    return container.blank? ? "main-container" : container
  end

private
  def admin?
    return false unless current_user
    current_user.role.super?
  end

  def current_user
    if session.has_key?(:ostensible_user_id) #&& true_current_user.can_edit_user?(session[:ostensible_user_id])
      return @ostensible_user if defined?(@ostensible_user)
      return @ostensible_user = Usage::User.find_by_id(session[:ostensible_user_id])
    else
      return true_current_user
    end
  end


  def true_current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = Usage::UserSession.find
  end

  def permission_denied
    formats = request.format.js? ? [:js] : [:html]
    return render 'permission_denied', layout:false, status:401, formats:formats
  end

  def require_login
    if current_user.blank?
      redirect_to login_path, flash: {error: "You need to login before you continue"}
    end
  end

  def require_super
    require_login
    unless current_user.role.super?
      redirect_to root_path, flash: {error: "You need admin privileges to continue"}
    end
  end
end
