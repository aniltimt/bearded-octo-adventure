class CreateQuotingQuoteParamDynamicSets < ActiveRecord::Migration
  def change
    create_table :quoting_quote_param_dynamic_sets do |t|
      t.integer :category_id
      t.integer :connection_id
      t.integer :face_amount
      t.integer :premium_mode_id

      t.timestamps
    end
  end
end
