class Crm::SystemTaskType < CluEnum
  self.table_name = 'crm_system_task_types'
  self.primary_key = :id
  # attr_accessible :title, :body
end
