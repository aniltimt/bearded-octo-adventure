# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_tli_table_rating_option, :class => 'Quoting::TliTableRatingOption' do
    name "MyString"
    value 1
    active false
  end
end
