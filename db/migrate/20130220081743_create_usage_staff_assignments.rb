class CreateUsageStaffAssignments < ActiveRecord::Migration
  def change
    create_table :usage_staff_assignments do |t|
      t.integer :administrative_assistant_id
      t.integer :case_manager_id
      t.integer :manager_id
      t.integer :policy_specialist_id
      t.integer :sales_assistant_id
      t.integer :sales_coordinator_id
      t.integer :sales_support_id

      t.timestamps
    end
  end
end
