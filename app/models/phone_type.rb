class PhoneType < CluEnum
  self.table_name = 'phone_types'
  self.primary_key = :id
  attr_accessible :name
end
