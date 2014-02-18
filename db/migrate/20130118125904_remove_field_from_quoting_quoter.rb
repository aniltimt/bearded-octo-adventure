class RemoveFieldFromQuotingQuoter < ActiveRecord::Migration
  def change
    add_column :quoting_quoters, :health_info_id, :integer
    remove_column :quoting_quoters, :birth
    remove_column :quoting_quoters, :gender
    remove_column :quoting_quoters, :inches
    remove_column :quoting_quoters, :feet
    remove_column :quoting_quoters, :weight
    remove_column :quoting_quoters, :smoker
    rename_column :quoting_relatives_diseases, :quoter_id, :quoter_param_state_id
  end
end
