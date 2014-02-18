class CreateProcessingSmmStatuses < ActiveRecord::Migration
  def change
    create_table :processing_smm_statuses do |t|
      t.integer :case_id
      t.integer :client_id
      t.string 	:desc
      t.integer :order_id
      t.date 		:scheduled

      t.timestamps
    end
  end
end
