class Quoting::TliTableRatingOption < CluEnum
  self.table_name = 'quoting_tli_table_rating_options'
  self.primary_key = :id
  attr_accessible :active, :name, :value
end
