class CreateCrmCases < ActiveRecord::Migration
  def change
    create_table :crm_cases do |t|
      t.boolean :active
      t.integer :agent_id
      t.integer :approved_details_id
      t.string :approved_illustration_file
      t.float :approved_premium_due
      t.boolean :blind
      t.integer :client_id
      t.boolean :cross_sell
      t.string :current_insurance_amount
      t.boolean :equal_share_contingent_bens
      t.boolean :equal_share_primary_bens
      t.string :exam_company
      t.boolean :active
      t.string :exam_num
      t.string :exam_status
      t.datetime :exam_time
      t.boolean :insurance_exists
      t.boolean :ipo
      t.integer :owner_id
      t.string :policy_number
      t.date :policy_period_expiration
      t.integer :quoted_details_id
      t.integer :status_id
      t.integer :submitted_details_id
      t.string :submitted_illustration_file
      t.integer :submitted_qualified
      t.boolean :underwriter_assist
      t.integer :up_sell
      t.timestamps
    end
  end
end
