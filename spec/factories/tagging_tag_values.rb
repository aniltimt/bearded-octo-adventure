# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging_tag_value, :class => 'Tagging::TagValue' do
    value { Forgery::Basic.text }
  end
end
