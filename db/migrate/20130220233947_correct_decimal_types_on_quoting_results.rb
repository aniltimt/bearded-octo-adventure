class CorrectDecimalTypesOnQuotingResults < ActiveRecord::Migration
  def up
    change_column :quoting_results, :monthly_premium, :decimal, :precision => 8, :scale => 2
    change_column :quoting_results, :annual_premium, :decimal, :precision => 8, :scale => 2
    change_column :quoting_results, :planned_modal_premium, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :quoting_results, :monthly_premium, :decimal, :precision => 2, :scale => 0
    change_column :quoting_results, :annual_premium, :decimal, :precision => 2, :scale => 0
    change_column :quoting_results, :planned_modal_premium, :decimal, :precision => 2, :scale => 0
  end
end
