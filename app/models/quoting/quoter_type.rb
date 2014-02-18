class Quoting::QuoterType < CluEnum
  self.table_name = 'quoting_quoter_types'
  self.primary_key = :id
  attr_accessible :name, :pinney_quoter_code
end
