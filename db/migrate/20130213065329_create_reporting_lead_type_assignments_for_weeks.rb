class CreateReportingLeadTypeAssignmentsForWeeks < ActiveRecord::Migration
  def change
    create_table :reporting_lead_type_assignments_for_weeks do |t|
      t.integer :agent_id
      t.integer :lead_type
      t.integer :sun
      t.integer :mon
      t.integer :tue
      t.integer :wed
      t.integer :thu
      t.integer :fri
      t.integer :sat

      t.timestamps
    end
  end
end
