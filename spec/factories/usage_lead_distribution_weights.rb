# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_lead_distribution_weight, :class => 'Usage::LeadDistributionWeight' do
    agent_id 1
    countdown { 1+rand(5) }
    premium_limit { rand(5) }
    tag_value_id 1
    weight { 1+rand(5) }
  end
end
