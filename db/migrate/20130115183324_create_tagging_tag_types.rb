class CreateTaggingTagTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW tagging_tag_types AS SELECT
            * FROM clu_enums.tagging_tag_types;')
  end

  def down
    execute('DROP VIEW IF EXISTS tagging_tag_types;')
  end
end
