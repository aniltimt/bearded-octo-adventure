class Processing::ExamOne::ControlCode < ActiveRecord::Base
  attr_accessible :carrier, :company_code, :control_code, :esign, :ez_life_profile, :policy_type, :state, :take_out_packet

  #Explicit column definitions for rspec-fire
  def company_code; super; end
  def control_code; super; end
end
