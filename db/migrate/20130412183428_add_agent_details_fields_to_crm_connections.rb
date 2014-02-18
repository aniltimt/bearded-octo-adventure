class AddAgentDetailsFieldsToCrmConnections < ActiveRecord::Migration
  def change
    add_column :crm_connections, :relationship_to_agent, :string
    add_column :crm_connections, :relationship_to_agent_start, :date
  end
end
