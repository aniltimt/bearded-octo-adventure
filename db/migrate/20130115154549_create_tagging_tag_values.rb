class CreateTaggingTagValues < ActiveRecord::Migration
  def change
    create_table :tagging_tag_values do |t|
      t.string :value
      t.timestamps
    end
  end
end
