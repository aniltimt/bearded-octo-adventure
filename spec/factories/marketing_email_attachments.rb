# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_email_attachment, :class => 'Marketing::Email::Attachment' do
    message_id 1
    filepath "MyString"
  end
end
