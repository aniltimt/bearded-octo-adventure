class ChangeQuotingRelativesDiseaseToBelongToCrmHealthInfo < ActiveRecord::Migration
  def change
    remove_column :quoting_relatives_diseases, :quoter_param_state_id
    add_column :quoting_relatives_diseases, :health_info_id, :integer
  end
end
