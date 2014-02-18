class AddRemoveFieldToQuotingQuoter < ActiveRecord::Migration
  def change
    add_column :quoting_quoters, :married, :boolean
    remove_column :quoting_quoters, :duration
    remove_column :quoting_quoters, :health_id
  end

end
