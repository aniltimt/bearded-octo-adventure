class Usage::AmlVendor < ActiveRecord::Base
  attr_accessible :name, :aml_vendor, :contracts_attributes, :aml_attributes
  
  # Associations
  has_many :contracts
  has_many :aml, :class_name => "Usage::Aml", :foreign_key => :vendor_id
  
 
  accepts_nested_attributes_for :contracts, :allow_destroy => true
  accepts_nested_attributes_for :aml, :allow_destroy => true
  
end
