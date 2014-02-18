class MaritalStatus < CluEnum
  self.table_name = 'marital_statuses'
  self.primary_key = :id
  attr_accessible :name

  #Explicit column definitions for rspec-fire
  def name; super; end
end
