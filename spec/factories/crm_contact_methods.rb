# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_contact_method, :class => 'Crm::ContactMethod' do
    name "Phone"
  end
end
