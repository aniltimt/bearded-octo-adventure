class RemoveColumnFromUsageAgentFieldSet < ActiveRecord::Migration
  
  def up
    remove_column :usage_agent_field_sets, :docusign_account_id
    remove_column :usage_agent_field_sets, :docusign_email
    remove_column :usage_agent_field_sets, :docusign_password
    remove_column :usage_agent_field_sets, :last_activity_at_browser
    remove_column :usage_agent_field_sets, :metlife_agent_id
    change_column :usage_agent_field_sets, :temporary_suspension, :boolean
  end

  def down
    add_column :usage_agent_field_sets, :docusign_account_id, :string
    add_column :usage_agent_field_sets, :docusign_email, :string
    add_column :usage_agent_field_sets, :docusign_password, :string
    add_column :usage_agent_field_sets, :last_activity_at_browser, :datetime
    add_column :usage_agent_field_sets, :metlife_agent_id, :string
    change_column :usage_agent_field_sets, :temporary_suspension, :datetime
  end
  
end
