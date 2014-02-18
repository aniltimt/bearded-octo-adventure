class Marketing::MarketingBaseController < ApplicationController
  before_filter :require_login, :has_membership

  def links
    @container_to_be_replaced = '#main-container > div'
  end

  private
  
  def has_membership
    membership = current_user.marketing_membership
    if membership.blank?
      permission_denied
    end
  end
  
end
