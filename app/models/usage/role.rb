class Usage::Role < CluEnum
  self.table_name = 'usage_roles'
  self.primary_key = :id
  attr_accessible :name

  SUPPORT_ROLES = ["sales agent", "sales support", "sales coordinator",
    "sales assistant", "administrative assistant", "case manager"]
  SUPER_ROLES = ["system", "developer", "admin"]

  SYSTEM_ID                   = 1
  DEVELOPER_ID                = 2
  ADMIN_ID                    = 3
  AGENT_ID                    = 4
  SALES_SUPPORT_ID            = 5
  SALES_COORDINATOR_ID        = 6
  SALES_ASSISTANT_ID          = 7
  ADMINISTRATIVE_ASSISTANT_ID = 8
  CASE_MANAGER                = 9
  MANAGER_ID                  = 10
  GROUP_ID                    = 11

  def sales_support?
    SUPPORT_ROLES.include?(self.name)
  end

  def super?
    SUPER_ROLES.include?(self.name)
  end

  def self.agent_id
    AGENT_ID
  end

  def self.group_id
    GROUP_ID
  end
end
