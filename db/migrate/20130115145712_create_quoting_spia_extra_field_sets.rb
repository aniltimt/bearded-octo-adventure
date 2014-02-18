class CreateQuotingSpiaExtraFieldSets < ActiveRecord::Migration
  def change
    create_table :quoting_spia_extra_field_sets do |t|
      t.string :income_option

      t.timestamps
    end
  end
end
