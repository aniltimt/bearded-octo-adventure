class UpdateQuotingMovingViolationsColumns < ActiveRecord::Migration
  def up
    add_column :quoting_moving_violations, :health_info_id, :integer
    remove_column :quoting_moving_violations, :connection_id
  end

  def down
  end
end
