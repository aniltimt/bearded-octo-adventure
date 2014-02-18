class CreateCrmEzlJoins < ActiveRecord::Migration
  def change
    create_table :crm_ezl_joins do |t|
      t.integer :ezl_id
      t.timestamps
    end
  end
end
