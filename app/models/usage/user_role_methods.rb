module Usage::UserRoleMethods
  def agent?
    role_id == Usage::Role::AGENT_ID
  end

  def group?
    role_id == Usage::Role::GROUP_ID
  end

  def manager?
    role_id == Usage::Role::MANAGER_ID
  end

  def sales_support?
    (Usage::Role::SALES_SUPPORT_ID..Usage::Role::CASE_MANAGER).include? role_id
  end

  def super?
    (Usage::Role::SYSTEM_ID..Usage::Role::ADMIN_ID).include? role_id
  end
end