class CreateUsageProfiles < ActiveRecord::Migration
  def change
    create_table :usage_profiles do |t|
      t.string :logo_file
      t.string :name
      t.string :phone
      t.integer :owner_id
      t.integer :ownership_id

      t.timestamps
    end
  end
end
