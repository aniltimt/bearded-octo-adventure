# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_contract, :class => 'Usage::Contract' do
    carrier_id 1
    status_id 1
    user_id 1
    aml_completion Time.now
    aml_vendor_id 1
    carrier_contract_id "MyString"
    corporate true
    effective_date Date.today
    expiration Date.today + 2.days
  end
end
