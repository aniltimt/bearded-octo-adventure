class CreateProcessingDocusignHelperCaseData < ActiveRecord::Migration
  def change
    create_table :processing_docusign_helper_case_data do |t|
      t.integer :case_id
      t.integer :envolope_id

      t.timestamps
    end
  end
end
