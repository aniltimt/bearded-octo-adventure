# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_search_condition, :class => 'Reporting::SearchCondition' do
    current false
    date_max "2013-01-14"
    date_min "2013-01-14"
    search_field_id 1
    search_condition_set_id 1
    text "MyString"
  end
end
