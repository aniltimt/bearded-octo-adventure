class AddParentIdToCrmConnections < ActiveRecord::Migration
  def change
    add_column :crm_connections, :parent_id, :integer
  end
end
