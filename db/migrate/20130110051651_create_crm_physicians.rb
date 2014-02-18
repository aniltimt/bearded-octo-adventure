class CreateCrmPhysicians < ActiveRecord::Migration
  def change
    create_table :crm_physicians do |t|
      t.string :address
      t.string :findings
      t.date :last_seen
      t.string :name
      t.string :phone
      t.string :reason
      t.timestamps
    end
  end
end
