# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_message_media_message, :class => 'Marketing::MessageMedia::Message' do
    template_id 1
    body "MyText"
    connection_id 1
    profile_id 1
    recipient "MyString"
    sender_id 1
    sent "2013-01-11 13:53:46"
    failed_attempts 1
  end
end
