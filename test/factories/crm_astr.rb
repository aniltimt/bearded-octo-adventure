
FactoryGirl.define do
	factory :astr, class: Crm::AutoSystemTaskRule do
		#associations: (will probably want to associate these to other factories later for integration testing?)
		role_id=Usage::Role.new.id
		task_type_id=Crm::SystemTaskType.new.id
		status_type_id=Crm::StatusType.new.id
		#other attributes:
		#none tested yet, since none are required to be non-null according to schema
	end
end