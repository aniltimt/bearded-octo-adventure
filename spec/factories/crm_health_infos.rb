# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_health_info, :class => 'Crm::HealthInfo' do   
    criminal false
    feet { rand(3)+4 }
    hazardous_avocation false
    health_history_id nil
    inches { rand(12) }
    moving_violation_history_id nil
    weight { rand(200) + 100 }
  end

  factory :crm_health_info_w_assoc, parent: :crm_health_info do
    association :health_history, factory: :crm_health_history
    association :moving_violation_history, factory: :crm_moving_violation_history
  end

  factory :crm_health_info_questionable, parent: :crm_health_info do
    bp_control_start { rand(20).years.ago }
    bp_diastolic { APP_CONFIG['bp_diastolic'].sample }
    bp_systolic { APP_CONFIG['bp_systolic'].sample  }
    cholesterol { APP_CONFIG['cholesterol'].sample }
    cholesterol_control_start { rand(20).years.ago }
    cholesterol_hdl { APP_CONFIG['cholesterol_hdl'].sample }
    cigarettes_per_month {rand(50)}
    cigars_per_month {rand(50)}
    criminal { [true, false].sample }
    hazardous_avocation { [true, false].sample }
    last_bp_treatment { rand(20).years.ago }
    last_cholesterol_treatment { rand(20).years.ago }
    last_cigar { rand(20).years.ago }
    last_cigarette { rand(20).years.ago }
    last_dl_suspension { rand(20).years.ago }
    last_dui_dwi { rand(20).years.ago }
    last_nicotine_patch_or_gum { rand(20).years.ago }
    last_pipe { rand(20).years.ago }
    last_reckless_driving { rand(20).years.ago }
    last_tobacco_chewed { rand(20).years.ago }
    penultimate_car_accident { rand(20).years.ago }
    association :health_history, factory: :crm_health_history_questionable
    association :moving_violation_history, factory: :crm_moving_violation_history_questionable
    after :create do |health_info, evaluator|
      create_list :quoting_relatives_disease, rand(4), health_info:health_info
    end
  end
end