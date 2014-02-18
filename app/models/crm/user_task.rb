class Crm::UserTask < ActiveRecord::Base
  attr_accessible :created_by, :assigned_to, :task_id
  
  # Associations
   belongs_to :created_by, :foreign_key => :created_by, :class_name => "Usage::User"
   belongs_to :assigned_to, :foreign_key => :assigned_to, :class_name => "Usage::User"
   belongs_to :system_task, :foreign_key => :system_task_id, :class_name => "Crm::SystemTask"
end
