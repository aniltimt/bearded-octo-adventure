class CreateUsageAmls < ActiveRecord::Migration
  def change
    create_table :usage_amls do |t|
      t.date :completion
      t.integer :vendor_id

      t.timestamps
    end
  end
end
