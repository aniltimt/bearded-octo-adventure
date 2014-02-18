# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_lead_distribution, :class => 'Usage::LeadDistribution' do
    count 1
    date ""
    agent_id 1
  end
end
