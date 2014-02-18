class CreateTaggingTags < ActiveRecord::Migration
  def change
    create_table :tagging_tags do |t|
      t.integer :client_id
      t.integer :tag_key_id
      t.integer :tag_value_id
      t.integer :tag_type_id
      t.integer :user_id
      t.timestamps
    end
  end
end
