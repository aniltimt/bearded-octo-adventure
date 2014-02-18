class CreateCrmMovingViolationHistories < ActiveRecord::Migration
  def change
  	create_table :crm_moving_violation_histories do |t|
  		[	:last_6_mo,
  			:last_1_yr,
  			:last_2_yr,
  			:last_3_yr,
  			:last_5_yr,
  			].each{|col| t.integer col }
  		t.timestamps
  	end

  	add_column :crm_health_infos, :moving_violation_history_id, :integer
  end
end
