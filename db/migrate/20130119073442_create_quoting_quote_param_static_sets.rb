class CreateQuotingQuoteParamStaticSets < ActiveRecord::Migration
  def change
    create_table :quoting_quote_param_static_sets do |t|
      t.integer :bp_systolic
      t.integer :bp_diasatolic
      t.integer :bp_control_duration
      t.integer :connection_id
      t.integer :cholesterol
      t.integer :cholesterol_control_duration
      t.float :cholesterol_hdl
      t.boolean :criminal
      t.boolean :hazardous_avocation
      t.integer :health_id
      t.date :last_bp_treatment
      t.date :last_cholesterol_treatment
      t.date :last_dl_suspension
      t.date :last_dui
      t.date :last_reckless_driving
      t.date :penultimate_car_accident
      t.integer :policy_type_id
      t.boolean :alcohol_or_drugs
      t.boolean :alzheimers
      t.boolean :asthma
      t.boolean :basal_cell_skin_cancer
      t.boolean :cancer
      t.boolean :copd
      t.boolean :crohns
      t.boolean :depression
      t.boolean :diabetes
      t.boolean :epilepsy
      t.boolean :heart_disease
      t.boolean :kidney_or_liver_disease
      t.boolean :mental_illness
      t.boolean :multiple_sclerosis
      t.boolean :rheumatoid_arthritis
      t.boolean :sleep_apnea
      t.boolean :stroke
      t.boolean :ulcerative_colitis_or_ileitis
      t.boolean :vascular_disease
      t.boolean :emphysema

      t.timestamps
    end
  end
end
