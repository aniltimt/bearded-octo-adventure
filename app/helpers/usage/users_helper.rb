module Usage::UsersHelper
  def get_contact_info_for
    @usage_user ? '-usage-user' : ''
  end
  
  def check_membership(user, module_name)
    @membership = module_name.find_by_owner_id(user)
    if @membership.blank?
      return false
    else
      return true
    end
  end
    
  def link_to_show(module_name, membership)
    if module_name == Marketing::Membership
      return marketing_membership_path(membership)
    elsif module_name == Reporting::Membership
      return reporting_membership_path(membership)
    elsif module_name == Tagging::Membership
      return tagging_membership_path(membership)
    end
  end
  
  def link_to_new(module_name, membership)
    if module_name == Marketing::Membership
      return new_marketing_membership_path
    elsif module_name == Reporting::Membership
      return new_reporting_membership_path
    elsif module_name == Tagging::Membership
      return new_tagging_membership_path
    end
  end
  
  def link_to_edit(module_name, membership)
    if module_name == Marketing::Membership
      return edit_marketing_membership_path(membership.id)
    elsif module_name == Reporting::Membership
      return edit_reporting_membership_path(membership.id)
    elsif module_name == Tagging::Membership
      return edit_tagging_membership_path(membership.id)
    end
  end
end
