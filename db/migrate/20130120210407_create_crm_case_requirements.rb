class CreateCrmCaseRequirements < ActiveRecord::Migration
  def change
    create_table :crm_case_requirements do |t|
      t.string :name
      t.string :required_of
      t.date :ordered
      t.date :recieved
      t.string :requirement_type
      t.string :status

      t.timestamps
    end
  end
end
