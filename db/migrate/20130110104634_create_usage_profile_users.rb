class CreateUsageProfileUsers < ActiveRecord::Migration
  def up
    create_table :usage_profiles_users, :id => false do |t|
      t.integer :profile_id
      t.integer :user_id
    end
  end

  def down
    drop_table :usage_profiles_users
  end
end
