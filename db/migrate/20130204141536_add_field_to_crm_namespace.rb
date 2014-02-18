class AddFieldToCrmNamespace < ActiveRecord::Migration
  def change
    add_column :crm_beneficiaries, :case_id, :integer
    add_column :crm_notes, :case_id, :integer
    add_column :crm_ezl_joins, :connection_id, :integer
    add_column :crm_physicians, :connection_id, :integer
  end
end
