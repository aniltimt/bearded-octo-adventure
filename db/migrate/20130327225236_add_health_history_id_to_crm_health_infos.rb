class AddHealthHistoryIdToCrmHealthInfos < ActiveRecord::Migration
  def change
    add_column :crm_health_infos, :health_history_id, :integer
  end
end
