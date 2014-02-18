# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging_tag_key, :class => 'Tagging::TagKey' do
    name { Forgery::Basic.text }
  end
end
