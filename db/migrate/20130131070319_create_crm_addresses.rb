class CreateCrmAddresses < ActiveRecord::Migration
  def change
    create_table :crm_addresses do |t|
      t.integer :connection_id
      t.integer :user_id
      t.string :value

      t.timestamps
    end
  end
end
