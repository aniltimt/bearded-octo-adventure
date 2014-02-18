class AddCompanyCodeToProcessingExamOneControlCodes < ActiveRecord::Migration
  def change
    add_column :processing_exam_one_control_codes, :company_code, :string
  end
end
