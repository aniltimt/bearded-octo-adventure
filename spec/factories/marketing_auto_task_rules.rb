# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_auto_task_rule, :class => 'Marketing::AutoTaskRule' do
    campaign_id 1
    auto_system_task_rule_id 1
  end
end
