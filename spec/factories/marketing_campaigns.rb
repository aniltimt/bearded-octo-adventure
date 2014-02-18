# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_campaign, :class => 'Marketing::Campaign' do
    name {Forgery::Name.first_name}
    owner_id nil
    ownership_id { enum_value Ownership }
  end
end
