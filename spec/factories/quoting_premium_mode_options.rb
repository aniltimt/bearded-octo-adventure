# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_premium_mode_option, :class => 'Quoting::PremiumModeOption' do
    name "MyString"
    value "MyString"
    active 1
  end
end
