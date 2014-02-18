class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :company
      t.integer :preferred_contact_method_id
      t.string :fax
      t.string :city
      t.integer :state_id
      t.string :zip

      t.timestamps
    end
  end
end
