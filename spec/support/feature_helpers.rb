module FeatureHelpers

  def current_user
    @current_user ||= Usage::User.where(role_id:role_id).last
  end

  def role_id
    Usage::Role.find_by_name('sales agent').id
  end

end