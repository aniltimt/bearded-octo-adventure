# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_task, :class => 'Marketing::Task' do
    campaign_id 1
    client_id 1
    system_task_id 1
  end
end
