class CreateCrmPhysicianTypes < ActiveRecord::Migration
  def change
    create_table :crm_physician_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
