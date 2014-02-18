class Crm::AutoUserTaskRule < ActiveRecord::Base
  attr_accessible :role_id, :auto_task_id
  
  # Associations
  belongs_to :role, :foreign_key => :role_id, :class_name => "Usage::Role"
end
