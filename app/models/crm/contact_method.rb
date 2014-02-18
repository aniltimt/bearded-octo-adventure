class Crm::ContactMethod < CluEnum
  self.table_name = 'crm_contact_methods'
  self.primary_key = :id
  # attr_accessible :title, :body
end
