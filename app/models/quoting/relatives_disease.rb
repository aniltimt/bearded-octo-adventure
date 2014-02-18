class Quoting::RelativesDisease < ActiveRecord::Base
  attr_accessible :age_of_contraction, :age_of_death, :basal_cell_carcinoma, 
                  :breast_cancer, :cardiovascular_disease, 
                  :cardiovascular_impairments, 
                  :cerebrovascular_disease, :colon_cancer, 
                  :coronary_artery_disease, :diabetes, :intestinal_cancer, 
                  :kidney_disease, :malignant_melanoma, 
                  :other_internal_cancer, :ovarian_cancer, :parent, 
                  :prostate_cancer
  attr_accessible :health_info, :health_info_id
                  
  # Associations
  belongs_to :health_info, class_name:"Crm::HealthInfo", foreign_key:"health_info_id"
end
