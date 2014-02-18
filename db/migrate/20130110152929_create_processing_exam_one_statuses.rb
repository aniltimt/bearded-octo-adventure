class CreateProcessingExamOneStatuses < ActiveRecord::Migration
  def change
    create_table :processing_exam_one_statuses do |t|
      t.integer 	:case_id
      t.string 		:desc
      t.datetime 	:completed_at

      t.timestamps
    end
  end
end
