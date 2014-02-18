class CreateUsageAscendentsDescendents < ActiveRecord::Migration
  def change
    create_table :usage_ascendents_descendents, :id => false do |t|
      t.integer :ascendent_id
      t.integer :descendent_id
    end
  end
end
