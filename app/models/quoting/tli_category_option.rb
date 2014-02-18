class Quoting::TliCategoryOption < CluEnum
  self.table_name = 'quoting_tli_category_options'
  self.primary_key = :id
  attr_accessible :active, :compulife_code, :name, :duration
end
