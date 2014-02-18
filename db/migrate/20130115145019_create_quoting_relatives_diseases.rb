class CreateQuotingRelativesDiseases < ActiveRecord::Migration
  def change
    create_table :quoting_relatives_diseases do |t|
      t.boolean :basal_cell_carcinoma
      t.boolean :breast_cancer
      t.boolean :cardiovascular_disease
      t.boolean :cardiovascular_impairments
      t.boolean :cerebrovascular_disease
      t.boolean :colon_cancer
      t.boolean :coronary_artery_disease
      t.boolean :diabetes
      t.boolean :intestinal_cancer
      t.boolean :kidney_disease
      t.boolean :malignant_melanoma
      t.boolean :other_internal_cancer
      t.boolean :ovarian_cancer
      t.boolean :prostate_cancer
      t.integer :age_of_contraction
      t.integer :age_of_death
      t.boolean :parent
      t.integer :quoter_id

      t.timestamps
    end
  end
end
