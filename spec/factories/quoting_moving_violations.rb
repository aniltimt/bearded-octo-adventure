# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_moving_violation, :class => 'Quoting::MovingViolation' do
    health_info_id 1
    date { 12.years.ago }
  end
end
