# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_role, :class => 'Usage::Role' do
    name "sales support"
  end
end
