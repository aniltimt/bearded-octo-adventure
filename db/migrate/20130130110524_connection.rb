class Connection < ActiveRecord::Migration
  def up
    rename_table :crm_clients, :crm_connections
  end

  def down
    rename_table :crm_connections, :crm_clients
  end
end
