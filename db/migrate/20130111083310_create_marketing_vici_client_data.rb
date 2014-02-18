class CreateMarketingViciClientData < ActiveRecord::Migration
  def change
    create_table :marketing_vici_client_data do |t|
      t.integer :client_id
      t.integer :vici_id

      t.timestamps
    end
  end
end
