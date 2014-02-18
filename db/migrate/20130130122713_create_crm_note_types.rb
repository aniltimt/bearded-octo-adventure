class CreateCrmNoteTypes < ActiveRecord::Migration
  def up
    execute('CREATE VIEW crm_note_types AS SELECT
            * FROM clu_enums.crm_note_types;')
  end

  def down
    execute('DROP VIEW IF EXISTS crm_note_types;')
  end
end
