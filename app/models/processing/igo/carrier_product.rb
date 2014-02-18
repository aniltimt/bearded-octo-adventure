class Processing::Igo::CarrierProduct < ActiveRecord::Base
  table_name "processing_igo_carrier_product"

  attr_accessible :carrier_id, :carrier_name, :product_id, :product_name, :product_type_id
end
