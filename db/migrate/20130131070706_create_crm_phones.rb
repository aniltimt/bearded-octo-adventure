class CreateCrmPhones < ActiveRecord::Migration
  def change
    create_table :crm_phones do |t|
      t.integer :connection_id
      t.integer :user_id
      t.string :ext
      t.integer :phone_type_id
      t.string :value

      t.timestamps
    end
  end
end
