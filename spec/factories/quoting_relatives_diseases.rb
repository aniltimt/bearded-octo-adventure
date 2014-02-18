# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quoting_relatives_disease, :class => 'Quoting::RelativesDisease' do
    age_of_contraction { rand(90) }
    age_of_death { rand(90) }
    basal_cell_carcinoma { [false,true].sample }
    breast_cancer { [false,true].sample }
    cardiovascular_disease { [false,true].sample }
    cardiovascular_impairments { [false,true].sample }
    cerebrovascular_disease { [false,true].sample }
    colon_cancer { [false,true].sample }
    coronary_artery_disease { [false,true].sample }
    diabetes { [false,true].sample }
    intestinal_cancer { [false,true].sample }
    kidney_disease { [false,true].sample }
    malignant_melanoma { [false,true].sample }
    other_internal_cancer { [false,true].sample }
    ovarian_cancer { [false,true].sample }
    parent { [false,true].sample }
    prostate_cancer { [false,true].sample }
  end
end
