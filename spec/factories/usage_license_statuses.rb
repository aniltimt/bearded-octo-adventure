# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_license_status, :class => 'Usage::LicenseStatus' do
    value "MyString"
  end
end
