class AddQuoteFieldsToQuotingResult < ActiveRecord::Migration
  def change
    [ :category_id,
      :health_class_id,
      :premium_mode_id,
    ].each{ |col| add_column :quoting_results, col, :integer }

    add_column :quoting_results, :face_amount, :decimal, precision:8, scale:2
  end

  def down
    add_column :quoting_results, :quote_param_dyn_id, :integer
  end

  def up
    remove_column :quoting_results, :quote_param_dyn_id
  end
end
