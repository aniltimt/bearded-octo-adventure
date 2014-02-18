class Crm::MovingViolationHistory < ActiveRecord::Base
  attr_protected :id, :created_at, :updated_at

  has_one :health_info, class_name:"Crm::HealthInfo"

  def more_than_one?
    (last_6_mo || 0) + (last_1_yr || 0) + (last_2_yr || 0) + (last_3_yr || 0) + (last_5_yr || 0) > 1
  end
end