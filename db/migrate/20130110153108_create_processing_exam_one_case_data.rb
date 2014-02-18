class CreateProcessingExamOneCaseData < ActiveRecord::Migration
  def change
    create_table :processing_exam_one_case_data do |t|
      t.integer :case_id
      t.boolean :info_sent
      t.string 	:or01_code
      t.string 	:schedule_now_code

      t.timestamps
    end
  end
end
