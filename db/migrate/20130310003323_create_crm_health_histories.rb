class CreateCrmHealthHistories < ActiveRecord::Migration
  def change
    create_table :crm_health_histories do |t|
      t.boolean :diabetes_1
      t.boolean :diabetes_2
      t.boolean :diabetes_neuropathy
      t.boolean :anxiety
      t.boolean :depression
      t.boolean :epilepsy
      t.boolean :parkinsons
      t.boolean :mental_illness
      t.boolean :alcohol_abuse
      t.boolean :drug_abuse
      t.boolean :elft
      t.boolean :hepatitis_c
      t.boolean :rheumatoid_arthritis
      t.boolean :asthma
      t.boolean :copd
      t.boolean :emphysema
      t.boolean :sleep_apnea
      t.boolean :crohns
      t.boolean :ulcerative_colitis_iletis
      t.boolean :weight_loss_surgery
      t.boolean :breast_cancer
      t.boolean :prostate_cancer
      t.boolean :skin_cancer
      t.boolean :internal_cancer
      t.boolean :atrial_fibrillations
      t.boolean :heart_murmur_valve_disorder
      t.boolean :irregular_heart_beat
      t.boolean :heart_attack
      t.boolean :stroke
      t.boolean :vascular_disease

      t.timestamps
    end
  end
end
