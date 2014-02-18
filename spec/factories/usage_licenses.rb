# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usage_license, :class => 'Usage::License' do
    status_id 1
    state_id 1
    expiration_warning_sent false
    corporate true
    effective_date Date.today
    expiration Date.today + 2.days
    number "7894561230"
  end
end
