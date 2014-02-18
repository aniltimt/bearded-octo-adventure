class CreateCrmActivities < ActiveRecord::Migration
  def change
    create_table :crm_activities do |t|
      t.integer :activity_type_id
      t.integer :connection_id
      t.string :description
      t.integer :foreign_key
      t.integer :owner_id
      t.integer :status_id
      t.integer :user_id

      t.timestamps
    end
  end
end
