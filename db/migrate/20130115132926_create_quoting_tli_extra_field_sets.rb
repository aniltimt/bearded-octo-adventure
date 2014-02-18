class CreateQuotingTliExtraFieldSets < ActiveRecord::Migration
  def change
    create_table :quoting_tli_extra_field_sets do |t|
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
      t.boolean :emphysema
      t.boolean :heart_disease
      t.boolean :kidney_or_liver_disease
      t.boolean :mental_illness
      t.boolean :multiple_sclerosis
      t.boolean :rheumatoid_arthritis
      t.boolean :sleep_apnea
      t.boolean :stroke
      t.boolean :ulcerative_colitis_or_ileitis
      t.boolean :vascular_disease
      t.integer :bp_systolic
      t.integer :bp_diasatolic
      t.integer :bp_control_duration
      t.integer :category_id
      t.integer :cholesterol
      t.integer :cholesterol_control_duration
      t.float :cholesterol_hdl
      t.integer :cigars_per_month
      t.integer :cigarettes_per_month
      t.boolean :criminal
      t.integer :health_id
      t.date :last_bp_treatment
      t.date :last_cholesterol_treatment
      t.date :last_dl_suspension
      t.date :last_dui
      t.date :last_tobacco_chewed
      t.date :last_cigar
      t.date :last_cigarette
      t.date :last_nicotine_patch_or_gum
      t.date :last_pipe
      t.date :last_reckless_driving
      t.integer :moving_violations_in_1_yr
      t.integer :moving_violations_in_2_yr
      t.integer :moving_violations_in_3_yr
      t.integer :moving_violations_in_5_yr
      t.integer :moving_violations_in_6_mo
      t.date :penultimate_car_accident
      t.integer :policy_type_id
      t.integer :quoter_id

      t.timestamps
    end
  end
end
