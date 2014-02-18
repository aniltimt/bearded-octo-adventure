class CreateReportingLeadTypeAssignmentTotals < ActiveRecord::Migration
  def change
    create_table :reporting_lead_type_assignment_totals do |t|
      t.integer :count
      t.integer :lead_type
      t.date :start

      t.timestamps
    end
  end
end
