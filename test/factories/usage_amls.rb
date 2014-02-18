# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_aml, :class => 'Usage::Aml' do
    completion "2013-03-20"
    vendor_id 1
  end
end
