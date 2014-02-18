class CreateProcessingIgos < ActiveRecord::Migration
  def change
    create_table :processing_igos do |t|

      t.timestamps
    end
  end
end
