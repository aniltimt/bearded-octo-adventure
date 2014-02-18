class CreateCrmNotes < ActiveRecord::Migration
  def change
    create_table :crm_notes do |t|
      t.boolean :confidential
      t.integer :user_id
      t.integer :note_type_id
      t.text :text
      t.string :title
      
      t.timestamps
    end
  end
end
