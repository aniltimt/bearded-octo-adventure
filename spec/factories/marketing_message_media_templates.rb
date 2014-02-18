# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_message_media_template, :class => 'Marketing::MessageMedia::Template' do
    owner_id 1
    ownership_id 1
    body "MyText"
  end
end
