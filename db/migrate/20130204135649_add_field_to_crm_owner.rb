class AddFieldToCrmOwner < ActiveRecord::Migration
  def change
    add_column :crm_owners, :case_id, :integer
    remove_column :crm_cases, :owner_id
  end
end
