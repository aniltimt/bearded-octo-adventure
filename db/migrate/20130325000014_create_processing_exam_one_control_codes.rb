class CreateProcessingExamOneControlCodes < ActiveRecord::Migration
  def change
    create_table :processing_exam_one_control_codes do |table|
      table.string  :carrier
      table.integer :control_code
      table.boolean :esign
      table.boolean :ez_life_profile
      table.string  :policy_type
      table.string  :state
      table.boolean :take_out_packet
    end
  end
end
