class CreateUsageContracts < ActiveRecord::Migration
  def change
    create_table :usage_contracts do |t|
      t.integer :carrier_id
      t.integer :state_id
      t.string :uid
      t.integer :user_id

      t.timestamps
    end
  end
end
