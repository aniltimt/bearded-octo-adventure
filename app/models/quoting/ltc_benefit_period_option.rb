class Quoting::LtcBenefitPeriodOption < CluEnum
  self.table_name = 'quoting_ltc_benefit_period_options'
  self.primary_key = :id
  attr_accessible :name, :value
end
