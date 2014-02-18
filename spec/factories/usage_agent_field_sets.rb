FactoryGirl.define do
  factory :usage_agent_field_set, class:'Usage::AgentFieldSet' do
    premium_limit { 10 ** rand(3) * 100000}
    temporary_suspension false
  end
end
