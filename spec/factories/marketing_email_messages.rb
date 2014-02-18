# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_email_message, :class => 'Marketing::Email::Message' do
    subject "MyString"
    template_id 1
    topic "MyString"
    body "MyText"
    profile_id 1
    recipient Forgery(:internet).email_address
    sender_id 1
    failed_attempts 1
  end
end
