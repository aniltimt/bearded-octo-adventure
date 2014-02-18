class UpdateTaggingTag < ActiveRecord::Migration
  def up
    add_column :tagging_tags, :connection_id, :integer
  end

  def down
  end
end
