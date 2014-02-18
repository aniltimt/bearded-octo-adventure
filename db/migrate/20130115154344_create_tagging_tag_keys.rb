class CreateTaggingTagKeys < ActiveRecord::Migration
  def change
    create_table :tagging_tag_keys do |t|
      t.string :name
      t.timestamps
    end
  end
end
