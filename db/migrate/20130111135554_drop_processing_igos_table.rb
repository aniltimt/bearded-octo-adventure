class DropProcessingIgosTable < ActiveRecord::Migration
  def up
		drop_table :processing_igos
  end

  def down
		create_table :processing_igos do |t|

      t.timestamps
		end
  end
end
