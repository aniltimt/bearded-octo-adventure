class CreateCrmStatusTypes < ActiveRecord::Migration
  def change
    create_table :crm_status_types do |t|
      t.string :color
      t.string :name
      t.integer :sort_order
      t.integer :owner_id
      t.integer :ownership_id
      t.timestamps
    end
  end
end
