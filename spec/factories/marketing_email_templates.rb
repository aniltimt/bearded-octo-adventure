# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_email_template, :class => 'Marketing::Email::Template' do
    owner_id 1
    ownership_id 1
    body "MyText"
    subject "MyString"
    name Forgery::Name.first_name
  end
end
