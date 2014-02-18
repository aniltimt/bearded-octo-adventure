# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging_membership, :class => 'Tagging::Membership' do
    custom_tags_privilege false
    owner_id 1
    ownership_id 1
  end
end
