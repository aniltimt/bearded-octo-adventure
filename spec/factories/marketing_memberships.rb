# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_membership, :class => 'Marketing::Membership' do
    owner_id 1
    ownership_id 1
    canned_template_privilege false
    custom_template_privilege false
  end
end
