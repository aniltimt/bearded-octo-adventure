class Quoting::LtcInflationProtectionOption < CluEnum
  self.table_name = 'quoting_ltc_inflation_protection_options'
  self.primary_key = :id
  attr_accessible :attribute19, :name, :value
end
