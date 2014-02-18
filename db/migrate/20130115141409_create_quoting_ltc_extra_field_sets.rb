class CreateQuotingLtcExtraFieldSets < ActiveRecord::Migration
  def change
    create_table :quoting_ltc_extra_field_sets do |t|
      t.integer :benefit_period_id
      t.integer :elimination_period
      t.integer :health_id
      t.integer :inflation_protection_id
      t.integer :quoter_id
      t.boolean :shared_benefit

      t.timestamps
    end
  end
end
