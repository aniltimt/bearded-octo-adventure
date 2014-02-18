class Crm::PolicyType < CluEnum
  self.table_name = 'crm_policy_types'
  self.primary_key = :id
  # attr_accessible :title, :body

  #Explicit column definitions for rspec-fire
  def name; super; end
end
