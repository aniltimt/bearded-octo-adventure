class AddFieldToUsageUser < ActiveRecord::Migration
  def change
    add_column :usage_users, :title, :string
    add_column :usage_users, :company, :string
    change_column :usage_users, :gender, :boolean
    add_column :usage_users, :current_login_at, :datetime
    add_column :usage_users, :current_login_ip, :string
    add_column :usage_users, :failed_login_count, :integer, :null => false, :default => 0
    add_column :usage_users, :last_login_at, :datetime
    add_column :usage_users, :last_login_ip, :string
    add_column :usage_users, :last_request_at, :datetime
    add_column :usage_users, :login_count, :integer, :null => false, :default => 0
    add_column :usage_users, :perishable_token, :string
    add_column :usage_users, :sales_support_field_set_id, :integer
    
    remove_column :usage_users, :email
    remove_column :usage_users, :home_phone
    remove_column :usage_users, :work_phone
    remove_column :usage_users, :work_phone_ext
    remove_column :usage_users, :mobile_phone
    remove_column :usage_users, :primary_phone_id
    remove_column :usage_users, :address1
    remove_column :usage_users, :address2
    remove_column :usage_users, :address3
    remove_column :usage_users, :licenses
    remove_column :usage_users, :business
  end
  

end
