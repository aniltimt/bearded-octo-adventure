# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_search_condition_set, :class => 'Reporting::SearchConditionSet' do
    name "MyString"
    search_id 1
  end
end
