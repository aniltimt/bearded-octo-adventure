class CreateReportingMemberships < ActiveRecord::Migration
  def change
    create_table :reporting_memberships do |t|
      t.integer :owner_id
      t.integer :ownership_id
      t.boolean :canned_reports_privilege
      t.boolean :custom_reports_privilege

      t.timestamps
    end
  end
end
