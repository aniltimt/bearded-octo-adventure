# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_organization, :class => 'Marketing::Organization' do
    group_id 1
  end
end
