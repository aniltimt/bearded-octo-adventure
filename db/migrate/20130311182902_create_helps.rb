class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|

      t.timestamps
    end
  end
end
