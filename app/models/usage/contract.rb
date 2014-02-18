class Usage::Contract < ActiveRecord::Base
  attr_accessible :carrier_id, :status_id, :user, :carrier, :state,
                  :aml_vendor_id, :carrier_contract_id, :state_id,
                  :corporate, :effective_date, :expiration, :agent_field_set_id, :appointment
 
  #validates_presence_of :state_id
  # Associations
  belongs_to :agent_field_set
  belongs_to :user
  belongs_to :carrier, :class_name => "Carrier"
  belongs_to :aml_vendor, :class_name => "Usage::AmlVendor"
  belongs_to :status, :class_name => "Usage::ContractStatus"
  belongs_to :state, class_name: "State"
  
  accepts_nested_attributes_for :aml_vendor, :allow_destroy => true
  
  validate :check_agent_license
  
  private 
  
  def check_agent_license
   if self.agent_field_set.licenses.where("state_id = #{self.state_id}").blank?
     errors.add(:state_id, "Agent not have license")
   end
    
  end
  
end