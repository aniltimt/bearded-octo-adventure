class State < CluEnum
  self.table_name = 'states'
  self.primary_key = :id
  attr_accessible :abbrev, :compulife_code, :name, :tz_id

  liquid_methods :abbrev, :name

  #Explicit column definitions for rspec-fire
  def abbrev; super; end
  def name; super; end
end
