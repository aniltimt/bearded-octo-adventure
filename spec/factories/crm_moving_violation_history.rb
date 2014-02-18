FactoryGirl.define do
  factory :crm_moving_violation_history, :class => 'Crm::MovingViolationHistory' do
    last_6_mo 0
    last_1_yr 0
    last_2_yr 0
    last_3_yr 0
    last_5_yr 0
  end

  factory :crm_moving_violation_history_questionable, parent: :crm_moving_violation_history do
    last_6_mo {rand(4)}
    last_1_yr {rand(4)}
    last_2_yr {rand(4)}
    last_3_yr {rand(4)}
    last_5_yr {rand(4)}
  end
end