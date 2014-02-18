class CreateProcessingIgoCarrierProductTable < ActiveRecord::Migration
  def change
    create_table :processing_igo_carrier_products do |table|
      table.integer :carrier_id
      table.string :carrier_name
      table.integer :product_id
      table.string :product_name
      table.integer:product_type_id
    end
  end
end
