# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_aml_vendor, :class => 'Usage::AmlVendor' do
    name "MyString"
  end
end
