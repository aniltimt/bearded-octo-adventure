# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_search_field, :class => 'Reporting::SearchField' do
    current false
    date_range false
    name "MyString"
    other_enum_name "MyString"
    other_enum_field "MyString"
    text_field false
  end
end
