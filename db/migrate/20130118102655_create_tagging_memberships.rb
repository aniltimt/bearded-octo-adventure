class CreateTaggingMemberships < ActiveRecord::Migration
  def change
    create_table :tagging_memberships do |t|
      t.boolean :custom_tags_privilege
      t.integer :owner_id
      t.integer :ownership_id

      t.timestamps
    end
  end
end
