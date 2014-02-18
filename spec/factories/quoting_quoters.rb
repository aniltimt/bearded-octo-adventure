# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_quoter, :class => 'Quoting::Quoter' do
    client_id 1
    coverage_amount 1
    married true
    income_option "MyString"
    joint false
    joint_birth "2013-01-11"
    joint_gender "MyString"
    joint_health "MyString"
    joint_state_id 1
    premium_mode_id 1
    quoter_type_id 1
    state_id 1
    health_info_id 1
  end
end
