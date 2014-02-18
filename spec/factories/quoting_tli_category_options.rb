# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_tli_category_option, :class => 'Quoting::TliCategoryOption' do
    name "MyString"
    compulife_code "MyString"
    active false
  end
end
