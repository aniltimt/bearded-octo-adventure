class Quoting::Quoter < ActiveRecord::Base
  attr_accessible :client_id, :coverage_amount, :income_option, :joint, 
                  :joint_birth, :joint_gender, :joint_health, 
                  :joint_state_id, :premium_mode_id, :quoter_type_id, 
                  :state_id, :married, :health_info_id
  # Associations
  belongs_to :client, :class_name => "Crm::Connection"
  belongs_to :health_info, :class_name => "Crm::HealthInfo"
  belongs_to :state, :class_name => "State"
  belongs_to :joint_state, :class_name => "State"
  belongs_to :premium_mode, :class_name => "Quoting::PremiumModeOption"
  belongs_to :quoter_type, :class_name => "Quoting::QuoterType"
end
