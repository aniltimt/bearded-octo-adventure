class CreateCrmOwners < ActiveRecord::Migration
  def change
    create_table :crm_owners do |t|
      t.string :tin
      t.timestamps
    end
  end
end
