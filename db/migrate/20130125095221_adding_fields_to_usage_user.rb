class AddingFieldsToUsageUser < ActiveRecord::Migration
  def up
    add_column :usage_users, :can_view_siblings_resources, :boolean
    add_column :usage_users, :can_edit_siblings_resources, :boolean
    add_column :usage_users, :can_view_descendents, :boolean
    add_column :usage_users, :can_edit_descendents, :boolean
    add_column :usage_users, :can_view_descendents_resources, :boolean
    add_column :usage_users, :can_edit_descendents_resources, :boolean
    add_column :usage_users, :can_view_nephews, :boolean
    add_column :usage_users, :can_edit_nephews, :boolean
    add_column :usage_users, :can_view_nephews_resources, :boolean
    add_column :usage_users, :can_edit_nephews_resources, :boolean
  end

  def down
    remove_column :usage_users, :can_view_siblings_resources
    remove_column :usage_users, :can_edit_siblings_resources
    remove_column :usage_users, :can_view_descendents
    remove_column :usage_users, :can_edit_descendents
    remove_column :usage_users, :can_view_descendents_resources
    remove_column :usage_users, :can_edit_descendents_resources
    remove_column :usage_users, :can_view_nephews
    remove_column :usage_users, :can_edit_nephews
    remove_column :usage_users, :can_view_nephews_resources
    remove_column :usage_users, :can_edit_nephews_resources
  end
end
