class RemoveFieldsFromCrmConnection < ActiveRecord::Migration
  def up
    remove_column :crm_connections, :last_cigar
    remove_column :crm_connections, :last_cigarette
    remove_column :crm_connections, :last_nicotine_patch_or_gum
    remove_column :crm_connections, :last_pipe
    remove_column :crm_connections, :last_tobacco_chewed
  end

  def down
    add_column :crm_connections, :last_tobacco_chewed, :string
    add_column :crm_connections, :last_pipe, :string
    add_column :crm_connections, :last_nicotine_patch_or_gum, :string
    add_column :crm_connections, :last_cigarette, :string
    add_column :crm_connections, :last_cigar, :string
  end
end
