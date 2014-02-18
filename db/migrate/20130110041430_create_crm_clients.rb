class CreateCrmClients < ActiveRecord::Migration
  def change
    create_table :crm_clients do |t|
      t.boolean :active
      t.integer :agent_id
      t.integer :birth_state_id
      t.string :birth_country
      t.integer :citizenship_id
      t.text :critical_note
      t.date :dl_expiration
      t.integer :dl_state_id
      t.string :dln
      t.boolean :email_send_failed
      t.string :employer
      t.integer :income
      t.string :ip_address
      t.date :last_cigar
      t.date :last_cigarette
      t.date :last_nicotine_patch_or_gum
      t.date :last_pipe
      t.date :last_tobacco_chewed     
      t.integer :marital_status_id
      t.integer :net_worth
      t.string :nickname
      t.text :note
      t.string :occupation
      t.integer :preferred_contact_method_id
      t.integer :profile_id
      t.text :priority_note
      t.integer :product_type
      t.string :saultation
      t.integer :spouse_id
      t.integer :spouse_income
      t.string :ssn
      t.string :suffix
      t.float :years_at_address
      
      t.timestamps
    end
  end
end
