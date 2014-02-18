class Crm::StatusType < ActiveRecord::Base
  include OwnedStereotype
  attr_accessible :color, :name, :sort_order, :owner_id, :ownership_id

  
  belongs_to :owner, :class_name => "Usage::User", :foreign_key => "owner_id"
  belongs_to :ownership, :class_name => "Ownership"
  has_many :auto_system_task_rules, class_name: "Crm::AutoSystemTaskRule"
end
