class Smoker < CluEnum
  self.table_name = 'smokers'
  self.primary_key = :id
  attr_accessible :compulife_value, :name
end
