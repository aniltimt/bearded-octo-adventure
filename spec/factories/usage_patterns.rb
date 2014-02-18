# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_pattern, :class => 'Usage::Pattern' do
    owner_id 1
    ownership_id 1
    field_name "MyString"
    operator_id 1
    model_for_pattern_id 1
    value "MyString"
  end
end
