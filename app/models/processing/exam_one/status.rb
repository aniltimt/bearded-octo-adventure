class Processing::ExamOne::Status < ActiveRecord::Base
  attr_accessible :case_id, :connection_id, :completed_at, :description, :exam_one_status_id

  belongs_to :case, class_name: "Crm::Case"
  belongs_to :crm_connection, class_name: "Crm::Connection", :foreign_key => :connection_id
end
