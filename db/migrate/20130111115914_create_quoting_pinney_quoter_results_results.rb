class CreateQuotingPinneyQuoterResultsResults < ActiveRecord::Migration
  def change
    create_table :quoting_results do |t|
      t.string :annual_premium
      t.integer :carrier_id
      t.string :carrier_health_class
      t.integer :coverage_amount
      t.integer :health_id
      t.string :plan_name
      t.float :planned_modal_premium
      t.integer :policy_type_id
      t.integer :premium_mode_id
      t.integer :smoker_id
      t.integer :table_rating_id
      t.integer :user_id

      t.timestamps
    end
  end
end
