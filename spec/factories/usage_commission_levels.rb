# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_commission_level, :class => 'Usage::CommissionLevel' do
    name "MyString"
  end
end
