class Crm::ConnectionType < CluEnum
  self.table_name = 'crm_connection_types'
  self.primary_key = :id
  # attr_accessible :title, :body
  has_many :crm_connections, :class_name => "Crm::Connection"
end
