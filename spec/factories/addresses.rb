# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, :class => 'Address' do
    contact_info
    value { Forgery::Address.street_address }
  end
end
