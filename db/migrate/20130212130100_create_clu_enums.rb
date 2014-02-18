class CreateCluEnums < ActiveRecord::Migration
  def change
    create_table :clu_enums, :id => false do |t|
      t.string :title

    end
  end
end
