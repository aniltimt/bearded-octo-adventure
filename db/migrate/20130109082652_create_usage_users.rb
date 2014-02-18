class CreateUsageUsers < ActiveRecord::Migration
  def change
    create_table :usage_users do |t|
      t.integer :agent_field_set_id
      t.string :business
      t.boolean :enabled
      t.integer :licenses
      t.string :login
      t.integer :parent_id
      t.integer :role_id
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :single_access_token
      
      # Person
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :birth
      t.string :gender
      
      # ContactInfo
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :email
      t.string :home_phone
      t.string :work_phone
      t.string :work_phone_ext
      t.string :mobile_phone
      t.integer :primary_phone_id
      t.integer :preferred_contact_method_id
      t.string :fax
      t.string :city
      t.integer :state_id
      t.string :zip
      
      # Privileges
      t.boolean :can_have_children
      t.boolean :can_edit_crm_core
      t.boolean :can_edit_crm_status_meta
      t.boolean :can_edit_crm_tags
      t.boolean :can_edit_profiles
      t.boolean :can_edit_self
      t.boolean :can_edit_siblings
      t.boolean :can_view_siblings

      t.timestamps
    end
  end
end
