class Crm::ActivityStatus < CluEnum
  self.table_name = 'crm_activity_statuses'
  self.primary_key = :id
  # attr_accessible :title, :body
end
