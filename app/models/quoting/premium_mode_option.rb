class Quoting::PremiumModeOption < CluEnum
  self.table_name = 'quoting_premium_mode_options'
  self.primary_key = :id
  attr_accessible :active, :name, :value
end
