class Quoting::LtcHealthClassOption < CluEnum
  self.table_name = 'quoting_ltc_health_class_options'
  self.primary_key = :id
  attr_accessible :name, :value
end
