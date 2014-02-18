class AddFieldsToCrmOwner < ActiveRecord::Migration
  def change
    add_column :crm_owners, :birth_or_trust_date, :date
    add_column :crm_owners, :genre_id, :integer
    add_column :crm_owners, :name, :string
    add_column :crm_owners, :gender, :boolean
    add_column :crm_owners, :relationship, :string
    add_column :crm_owners, :ssn, :string
    add_column :crm_owners, :trustee, :string
  end
end
