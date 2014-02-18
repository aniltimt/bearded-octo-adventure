class AddLogoToProfile < ActiveRecord::Migration
  def change
    remove_column :usage_profiles, :logo_file
    add_attachment :usage_profiles, :logo
  end
end
