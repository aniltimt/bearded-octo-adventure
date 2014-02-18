class Processing::ExamOne::CaseData < ActiveRecord::Base
	attr_accessible :case_id, :info_sent, :or01_code, :schedule_now_code

	belongs_to :case, class_name: 'Crm::Case'

	# ...
end
