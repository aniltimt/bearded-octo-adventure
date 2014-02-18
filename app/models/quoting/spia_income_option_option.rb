class Quoting::SpiaIncomeOptionOption < CluEnum
  self.table_name = 'quoting_spia_income_option_options'
  self.primary_key = :id
  attr_accessible :name, :value
end
