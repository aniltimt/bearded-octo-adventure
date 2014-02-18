require 'active_record_base_sample.rb'

FactoryGirl.define do
  factory :quoting_result, :class => 'Quoting::Quote' do
    annual_premium { rand(1000) + 0.1 }
    carrier_id nil
    carrier_health_class "preferred for us"
    category_id nil
    connection_id nil
    face_amount { APP_CONFIG['face_amounts'].sample }
    plan_name "my plan"
    planned_modal_premium 1.5
    policy_type_id nil
    premium_mode_id nil
    monthly_premium { rand(100).to_f }
    user_id nil
    # enums
    category { Quoting::TliCategoryOption::sample }
    health_class { Quoting::TliHealthClassOption::sample }
    policy_type { Crm::PolicyType::sample }
    premium_mode { Quoting::PremiumModeOption::sample }
    # associations
    association :carrier, factory: :carrier
  end
end
