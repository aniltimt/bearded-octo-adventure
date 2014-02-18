class Crm::Task < ActiveRecord::Base
   attr_accessible :label, :task_type_id
   
   # Associations
   belongs_to :task_type, :foreign_key => :task_type_id, :class_name => "Crm::SystemTaskType"
end
