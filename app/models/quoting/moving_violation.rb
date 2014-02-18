class Quoting::MovingViolation < ActiveRecord::Base
  attr_accessible :health_info_id, :date
  
  # Associations
  belongs_to :health_info, :class_name => "Crm::HealthInfo"
  
end
