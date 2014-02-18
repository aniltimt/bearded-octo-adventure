class AddDrivingAndHazardousAvocationFieldsToHealthInfo < ActiveRecord::Migration
  def change
  	t = :crm_health_infos

  	# Add boolean fields
  	add_column t, :criminal, :boolean
  	add_column t, :hazardous_avocation, :boolean
  	
  	# Add date fields
  	[
  		:last_dl_suspension,
  		:last_dui_dwi,
  		:last_reckless_driving,
  		:penultimate_car_accident
  		].each{ |field| add_column t, field, :date }
  end
end
