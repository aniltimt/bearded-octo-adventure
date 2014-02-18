# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_quoter_type, :class => 'Quoting::QuoterType' do
    name "MyString"
    pinney_quoter_code "MyString"
  end
end
