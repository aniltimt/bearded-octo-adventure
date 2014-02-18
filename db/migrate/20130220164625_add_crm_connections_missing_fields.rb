class AddCrmConnectionsMissingFields < ActiveRecord::Migration
  def change
    add_column :crm_connections, :nickname, :string
    rename_column :crm_connections, :product_type, :product_type_id
  end
end
