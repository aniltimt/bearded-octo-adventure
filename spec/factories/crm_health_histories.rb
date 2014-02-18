# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crm_health_history, :class => 'Crm::HealthHistory' do
    diabetes_1 false
    diabetes_2 false
    diabetes_neuropathy false
    anxiety false
    depression false
    epilepsy false
    parkinsons false
    mental_illness false
    alcohol_abuse false
    drug_abuse false
    elft false
    hepatitis_c false
    rheumatoid_arthritis false
    asthma false
    copd false
    emphysema false
    sleep_apnea false
    crohns false
    ulcerative_colitis_iletis false
    weight_loss_surgery false
    breast_cancer false
    prostate_cancer false
    skin_cancer false
    internal_cancer false
    atrial_fibrillations false
    heart_murmur_valve_disorder false
    irregular_heart_beat false
    heart_attack false
    stroke false
    vascular_disease false
  end

  factory :crm_health_history_questionable, parent: :crm_health_history do 
    diabetes_1 {[false,true].sample}
    diabetes_2 {[false,true].sample}
    diabetes_neuropathy {[false,true].sample}
    anxiety {[false,true].sample}
    depression {[false,true].sample}
    epilepsy {[false,true].sample}
    parkinsons {[false,true].sample}
    mental_illness {[false,true].sample}
    alcohol_abuse {[false,true].sample}
    drug_abuse {[false,true].sample}
    elft {[false,true].sample}
    hepatitis_c {[false,true].sample}
    rheumatoid_arthritis {[false,true].sample}
    asthma {[false,true].sample}
    copd {[false,true].sample}
    emphysema {[false,true].sample}
    sleep_apnea {[false,true].sample}
    crohns {[false,true].sample}
    ulcerative_colitis_iletis {[false,true].sample}
    weight_loss_surgery {[false,true].sample}
    breast_cancer {[false,true].sample}
    prostate_cancer {[false,true].sample}
    skin_cancer {[false,true].sample}
    internal_cancer {[false,true].sample}
    atrial_fibrillations {[false,true].sample}
    heart_murmur_valve_disorder {[false,true].sample}
    irregular_heart_beat {[false,true].sample}
    heart_attack {[false,true].sample}
    stroke {[false,true].sample}
    vascular_disease {[false,true].sample}
  end
end
