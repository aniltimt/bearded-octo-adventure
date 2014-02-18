class Usage::Aml < ActiveRecord::Base
  attr_accessible :completion, :vendor_id
  
  has_many :agent_field_set, :class_name => "Usage::AgentFieldSet", :foreign_key => :aml_id
  belongs_to :aml_vendor, :class_name => "Usage::AmlVendor"
end
