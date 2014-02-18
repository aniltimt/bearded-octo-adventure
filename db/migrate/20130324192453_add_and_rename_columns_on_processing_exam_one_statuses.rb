class AddAndRenameColumnsOnProcessingExamOneStatuses < ActiveRecord::Migration
  def change
    add_column :processing_exam_one_statuses, :connection_id, :integer
    add_column :processing_exam_one_statuses, :exam_one_status_id, :integer
    rename_column :processing_exam_one_statuses, :desc, :description
  end
end
