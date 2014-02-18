# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reporting_search, :class => 'Reporting::Search' do
    owner_id 1
    ownership_id 1
    name "MyString"
  end
end
