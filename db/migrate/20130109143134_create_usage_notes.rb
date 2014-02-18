class CreateUsageNotes < ActiveRecord::Migration
  def change
    create_table :usage_notes do |t|
      t.text :body
      t.integer :creator_id
      t.integer :user_id

      t.timestamps
    end
  end
end
