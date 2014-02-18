class Carrier < ActiveRecord::Base
  attr_accessible :abbrev, :compulify_code, :enabled, :naic_code, :name, :smm_id
  
  validates_presence_of :name
  
  # Association
  has_many :contracts, :class_name => "Usage::Contract"

  #Explicit column definitions for rspec-fire
  def name; super; end
  def smm_id; super; end
end
