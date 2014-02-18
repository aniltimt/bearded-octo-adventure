class CreateUsageLicenses < ActiveRecord::Migration
  def change
    create_table :usage_licenses do |t|
      t.date :expiration
      t.boolean :expiration_warning_sent
      t.string :number
      t.integer :status_id
      t.integer :user_id
      t.integer :state_id

      t.timestamps
    end
  end
end
