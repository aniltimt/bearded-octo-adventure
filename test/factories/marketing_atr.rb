
FactoryGirl.define do
	factory :atr, class: Marketing::AutoTaskRule do
	    campaign_id=Marketing::Campaign.new.id
	    auto_system_task_rule_id=Crm::AutoSystemTaskRule.new.id
	end
end