class Quoting::QuoteParamStaticSet < ActiveRecord::Base

  attr_accessible :bp_control_duration, :bp_diasatolic, :bp_systolic, :cholesterol, :cholesterol_control_duration,
                  :cholesterol_hdl, :connection_id, :criminal, :hazardous_avocation, :health_id, :last_bp_treatment,
                  :last_cholesterol_treatment, :last_dl_suspension, :last_dui, :last_reckless_driving,
                  :penultimate_car_accident, :policy_type_id

  # Compulife Medical Conditions a
  attr_accessible :alcohol_or_drugs, :alzheimers, :asthma, :basal_cell_skin_cancer, :cancer, :copd, :crohns,
                  :depression, :diabetes, :emphysema, :epilepsy, :heart_disease, :kidney_or_liver_disease,
                  :mental_illness, :multiple_sclerosis, :sleep_apnea, :rheumatoid_arthritis, :stroke,
                  :ulcerative_colitis_or_ileitis, :vascular_disease

  validates_uniqueness_of :connection_id

  # Associations
  belongs_to :crm_connection, :class_name => "Crm::Connection", :foreign_key => :connection_id
  belongs_to :health, :foreign_key => :health_id, :class_name => "TliHealthClassOption"
  has_many :relatives_diseases, :class_name => 'RelativesDisease', :foreign_key => :quoter_param_state_id

end
