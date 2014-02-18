class UpdateTableTaggingTags < ActiveRecord::Migration
  def up
     remove_column :tagging_tags, :client_id
  end

  def down
    add_column :tagging_tags, :client_id, :integer
  end
end
