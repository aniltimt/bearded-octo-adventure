class Quoting::NeliExtraFieldSet < ActiveRecord::Base
  attr_accessible :hiv, :in_ltc_facility, :quoter_id, 
                  :terminal, :tobacco
                  
  # Associations
  belongs_to :quoter
end
