# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_physician, :class => 'Crm::Physician' do
    address { Forgery::Address.street_address }
    connection_id nil
    findings "MyString"
    last_seen { 1.year.ago }
    name "MyString"
    phone { Forgery::Address.phone }
    physician_type_id { enum_value Crm::PhysicianType }
    reason "MyString"
    years_of_service { rand(20) }
  end
end
