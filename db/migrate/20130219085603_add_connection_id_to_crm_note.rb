class AddConnectionIdToCrmNote < ActiveRecord::Migration
  def up
    add_column :crm_notes, :connection_id, :integer
  end

  def down
    remove_column :crm_notes, :connection_id
  end
end
