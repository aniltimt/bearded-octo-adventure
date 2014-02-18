class TimeZone < CluEnum
  self.table_name = 'time_zones'
  self.primary_key = :id
  attr_accessible :name, :offset
end
