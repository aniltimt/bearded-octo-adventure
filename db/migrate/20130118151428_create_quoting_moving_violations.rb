class CreateQuotingMovingViolations < ActiveRecord::Migration
  def change
    create_table :quoting_moving_violations do |t|
      t.integer :connection_id
      t.date :date

      t.timestamps
    end
  end
end
