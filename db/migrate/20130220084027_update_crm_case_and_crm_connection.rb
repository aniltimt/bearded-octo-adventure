class UpdateCrmCaseAndCrmConnection < ActiveRecord::Migration
  def up
    change_table :crm_cases do |t|
      t.remove :admin_asst_id, :case_manager_id, :manager_id, :sales_asst_id, :sales_coordinator_id,
               :sales_support_id
      t.integer :staff_assignment_id
    end
    add_column :crm_connections, :staff_assignment_id, :integer
  end

  def down
    change_table :crm_cases do |t|
      t.integer :admin_asst_id, :case_manager_id, :manager_id, :sales_asst_id, :sales_coordinator_id,
               :sales_support_id
      t.remove :staff_assignment_id
    end
    remove_column :crm_connections, :staff_assignment_id
  end
end
