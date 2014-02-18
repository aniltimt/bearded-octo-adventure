class CreateQuotingQuoters < ActiveRecord::Migration
  def change
    create_table :quoting_quoters do |t|
      t.integer :feet
      t.integer :inches
      t.integer :smoker
      t.integer :weight
      t.date :birth
      t.integer :client_id
      t.integer :coverage_amount
      t.integer :duration
      t.string :gender
      t.integer :health_id
      t.string :income_option
      t.boolean :joint
      t.date :joint_birth
      t.string :joint_gender
      t.string :joint_health
      t.integer :joint_state_id
      t.integer :premium_mode_id
      t.integer :quoter_type_id
      t.integer :state_id

      t.timestamps
    end
  end
end
