class AddTemplateStereotypeFieldsToMarketingEmailTemplates < ActiveRecord::Migration
  def change
    add_column :marketing_email_templates, :name, :string
    add_column :marketing_email_templates, :description, :string
    add_column :marketing_email_templates, :enabled, :boolean
    add_attachment :marketing_email_templates, :thumbnail
  end
end
