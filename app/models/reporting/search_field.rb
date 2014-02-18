class Reporting::SearchField < CluEnum
  self.table_name = 'reporting_search_fields'
  self.primary_key = :id
  attr_accessible :current, :date_range, :name, :other_enum_field, :other_enum_name, :text_field
end
