class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :abbrev
      t.string :name
      t.string :compulify_code
      t.boolean :enabled
      t.integer :naic_code
      t.integer :smm_id

      t.timestamps
    end
  end
end
