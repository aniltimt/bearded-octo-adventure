# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_address, :class => 'EmailAddress' do
    contact_info
    value { Forgery::Internet.email_address }
  end
end
