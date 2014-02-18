# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_activity, :class => 'Crm::Activity' do
    activity_type_id { enum_value Crm::ActivityType }
    connection_id nil
    description "MyString"
    foreign_key nil
    owner_id nil
    status_id { enum_value Crm::ActivityStatus }
    user_id nil
  end
end
