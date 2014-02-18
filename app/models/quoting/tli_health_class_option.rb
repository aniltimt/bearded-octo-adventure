class Quoting::TliHealthClassOption < CluEnum
  self.table_name = 'quoting_tli_health_class_options'
  self.primary_key = :id
  attr_accessible :name, :value
end
