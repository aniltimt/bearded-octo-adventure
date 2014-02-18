# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_physician_type, :class => 'Crm::PhysicianType' do
    name "MyString"
  end
end
