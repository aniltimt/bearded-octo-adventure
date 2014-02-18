class Crm::Status < ActiveRecord::Base
  include Crm::BelongsToCaseStereotype

  attr_accessible :active, :case_id, :created_by, :current, :openness_id, :status_type_id, :system_task_id

  # Associations
  belongs_to :case, :foreign_key => :case_id, :class_name => "Crm::Case"
  has_one :crm_case, :class_name => "Crm::Case", :foreign_key => :status_id
  belongs_to :user, :foreign_key => :created_by, :class_name => "Usage::User"
  belongs_to :openness, :foreign_key => :openness_id, :class_name => "Crm::Openness"
  belongs_to :status_type, :foreign_key => :status_type_id, :class_name => "Crm::StatusType"
  has_many :system_tasks, class_name: "Crm::SystemTask"

  def create_auto_tasks
    #need to implement
  end
end
