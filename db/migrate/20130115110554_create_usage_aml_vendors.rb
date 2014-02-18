class CreateUsageAmlVendors < ActiveRecord::Migration
  def change
    create_table :usage_aml_vendors do |t|
      t.string :name

      t.timestamps
    end
  end
end
