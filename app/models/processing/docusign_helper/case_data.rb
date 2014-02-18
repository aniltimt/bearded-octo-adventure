class Processing::DocusignHelper::CaseData < ActiveRecord::Base
	include Processing::DocusignHelper

	attr_accessible :case_id, :envolope_id

	belongs_to :case, class_name: 'Crm::Case'

	# ...
end
