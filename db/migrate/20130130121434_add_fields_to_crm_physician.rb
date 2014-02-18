class AddFieldsToCrmPhysician < ActiveRecord::Migration
  def change
    add_column :crm_physicians, :physician_type_id, :integer
    add_column :crm_physicians, :year_of_service, :integer
  end
end
