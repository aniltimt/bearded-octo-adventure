class CorrectSpellingInCrmPhysicians < ActiveRecord::Migration
  def change
    rename_column :crm_physicians, :year_of_service, :years_of_service
  end
end
