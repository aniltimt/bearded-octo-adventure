class RemoveTable < ActiveRecord::Migration

  def change
    drop_table :quoting_tli_extra_field_sets
  end
  
end
