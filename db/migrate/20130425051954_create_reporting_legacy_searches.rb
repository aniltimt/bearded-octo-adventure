class CreateReportingLegacySearches < ActiveRecord::Migration
  def change
    create_table :reporting_legacy_searches do |t|
      t.string :search_name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :city
      t.string :zip
      t.string :phone
      t.string :email
      t.string :i_c
      t.string :status
      t.string :agent_name
      t.string :carrier_name
      t.string :lead_type
      t.string :app_status
      t.integer :age_from
      t.integer :age_to
      t.integer :state_id
      t.integer :owner_id
      t.integer :ownership_id
      t.integer :campaign_id
      t.integer :source
      t.integer :sales_support_id
      t.integer :profile_id
      t.integer :policy_type_id
      t.integer :face_amount_from
      t.integer :face_amount_to
      t.integer :annual_premium_from
      t.integer :annual_premium_to
      t.integer :status_category_id
      t.integer :status_id
      t.timestamps
    end
  end
end
