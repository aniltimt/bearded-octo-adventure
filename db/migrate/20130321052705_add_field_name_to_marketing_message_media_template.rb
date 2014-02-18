class AddFieldNameToMarketingMessageMediaTemplate < ActiveRecord::Migration
  def change
    add_column :marketing_message_media_templates, :name, :string
    add_column :marketing_message_media_templates, :description, :string
    add_column :marketing_message_media_templates, :enabled, :boolean
  end
end
