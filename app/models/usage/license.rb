class Usage::License < ActiveRecord::Base
  attr_accessible :agent_field_set, :agent_field_set_id,
                  :expiration, :expiration_warning_sent, :number, :status_id, :home, :p_and_c,
                  :state_id, :user_id, :user, :state, :corporate, :effective_date, :user_name,
                  :vehicle, :life, :agent_field_set_id
                  
  attr_accessor :user_name 
                  
  validates_presence_of :agent_field_set_id, :state_id, :number
  validates_uniqueness_of :state_id, :scope => [:agent_field_set_id]
  # Associations
  belongs_to :user
  belongs_to :agent_field_set
  belongs_to :state, class_name: "State"
  belongs_to :status, class_name: "Usage::LicenseStatus"
  
  
end
