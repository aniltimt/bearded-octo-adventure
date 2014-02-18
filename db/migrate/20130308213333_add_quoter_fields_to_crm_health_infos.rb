class AddQuoterFieldsToCrmHealthInfos < ActiveRecord::Migration
  def change
  	t = :crm_health_infos
  	# Add integer fields
  	[:bp_systolic, :bp_diastolic, :cholesterol].each do |field|
  		add_column t, field, :integer
  	end
  	# Add float fields
  	add_column t, :cholesterol_hdl, :float
  	# Add date fields
  	[:bp_control_start, :cholesterol_control_start, :last_bp_treatment, :last_cholesterol_treatment].each do |field|
  		add_column t, field, :date
  	end
  end
end
