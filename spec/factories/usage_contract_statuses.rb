# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_contract_status, :class => 'Usage::ContractStatus' do
    value "MyString"
  end
end
