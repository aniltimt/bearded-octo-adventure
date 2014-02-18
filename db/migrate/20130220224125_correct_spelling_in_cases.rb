class CorrectSpellingInCases < ActiveRecord::Migration
  def change
    rename_column :crm_cases, :blind, :bind
    add_column :crm_cases, :owner_id, :integer
  end
end
