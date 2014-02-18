class CreateProcessingAgencyWorkCaseData < ActiveRecord::Migration
  def change
    create_table :processing_agency_work_case_data do |t|
      t.integer :case_id
			t.integer :agency_works_id
      t.boolean :imported_to_agency_work

      t.timestamps
    end
  end
end
