class CreateQuotingNeliExtraFieldSets < ActiveRecord::Migration
  def change
    create_table :quoting_neli_extra_field_sets do |t|
      t.boolean :hiv
      t.boolean :in_ltc_facility
      t.boolean :terminal
      t.boolean :tobacco
      t.integer :quoter_id

      t.timestamps
    end
  end
end
