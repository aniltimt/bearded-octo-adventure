class CreateCrmBeneficiaries < ActiveRecord::Migration
  def change
    create_table :crm_beneficiaries do |t|
      t.boolean :contingent
      t.integer :percentage

      t.timestamps
    end
  end
end
