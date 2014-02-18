class AlterUsageLicenses < ActiveRecord::Migration
  def up
    add_column :usage_licenses, :home, :boolean
    add_column :usage_licenses, :life, :boolean
    add_column :usage_licenses, :p_and_c, :boolean
    add_column :usage_licenses, :vehicle, :boolean
    add_column :usage_licenses, :agent_field_set_id, :integer
  
  end

  def down
  end
end
