# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging_tag_type, :class => 'Tagging::TagType' do
    name { Forgery::Name.first_name }
  end
end
