class RemoveFieldFromQuotingResults < ActiveRecord::Migration
  def change
    add_column :quoting_results, :monthly_premium, :decimal, :precision => 2
    add_column :quoting_results, :connection_id, :integer
    add_column :quoting_results, :quote_param_dyn_id, :integer
    
    remove_column :quoting_results, :smoker_id
    remove_column :quoting_results, :health_id
    remove_column :quoting_results, :table_rating_id
    remove_column :quoting_results, :premium_mode_id
    remove_column :quoting_results, :coverage_amount
    
    change_column :quoting_results, :annual_premium, :decimal, :precision => 2
    change_column :quoting_results, :planned_modal_premium, :decimal, :precision => 2
    
  end

end
