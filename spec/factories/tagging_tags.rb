# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging_tag, :class => 'Tagging::Tag' do
    connection_id nil
    tag_key_id nil
    tag_type_id { enum_value Tagging::TagType }
    tag_value_id nil
    user_id nil
  end

  factory :tagging_tag_w_key, parent: :tagging_tag do
    association :tag_key, factory: :tagging_tag_key
  end

  factory :tagging_tag_w_value, parent: :tagging_tag_w_key do
    association :tag_value, factory: :tagging_tag_value
  end
end
