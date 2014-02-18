class AddPrimaryContactToCrmConnecton < ActiveRecord::Migration
  def change
    add_column :crm_connections, :primary_contact_id, :integer
  end
end
