class Processing::Smm::Status < ActiveRecord::Base
	attr_accessible :case_id, :client_id, :desc, :order_id, :scheduled

	belongs_to :case, 	class_name: 'Crm::Case'
	belongs_to :client,	class_name: 'Crm::Client'
end
