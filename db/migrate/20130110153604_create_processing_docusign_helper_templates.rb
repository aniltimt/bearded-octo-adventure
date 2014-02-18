class CreateProcessingDocusignHelperTemplates < ActiveRecord::Migration
  def change
    create_table :processing_docusign_helper_templates do |t|
      t.string :clu_name
      t.string :docusign_template_name
      t.string :docusign_template_id

      t.timestamps
    end
  end
end
