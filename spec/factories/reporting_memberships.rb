# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_membership, :class => 'Reporting::Membership' do
    owner_id 1
    ownership_id 1
    canned_reports_privilege false
    custom_reports_privilege false
  end
end
