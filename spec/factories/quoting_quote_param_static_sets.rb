# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_quote_param_static_set, :class => 'Quoting::QuoteParamStaticSet' do
    bp_systolic 1
    bp_diasatolic 1
    bp_control_duration 1
    connection_id 1
    cholesterol 1
    cholesterol_control_duration 1
    cholesterol_hdl 1.5
    criminal false
    hazardous_avocation false
    health_id 1
    last_bp_treatment "2013-01-19"
    last_cholesterol_treatment "2013-01-19"
    last_dl_suspension "2013-01-19"
    last_dui "2013-01-19"
    last_reckless_driving "2013-01-19"
    penultimate_car_accident "2013-01-19"
    policy_type_id 1
    alcohol_or_drugs false
    alzheimers false
    asthma false
    basal_cell_skin_cancer false
    cancer false
    copd false
    crohns false
    depression false
    diabetes false
    epilepsy false
    heart_disease false
    kidney_or_liver_disease false
    mental_illness false
    multiple_sclerosis false
    rheumatoid_arthritis false
    sleep_apnea false
    stroke false
    ulcerative_colitis_or_ileitis false
    vascular_disease false
    emphysema false
  end
end
