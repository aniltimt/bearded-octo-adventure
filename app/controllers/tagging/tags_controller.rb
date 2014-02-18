class Tagging::TagsController < ApplicationController

  def index
    if !params[:user_id].blank?
      user = Usage::User.find(params[:user_id])
      @recent_tags = Tagging::Tag.get_recent_tags_for_user(user)
      @system_tags = Tagging::Tag.get_system_tags_for_user(user)
      @custom_tags = Tagging::Tag.get_custom_tags_for_user(user)
      @recommended_tags = user.tag_keys.find(:all, :order => "tagging_tag_keys.created_at desc", :limit => 10)
    elsif params[:connection_id]
      connection = Crm::Connection.find(params[:connection_id])
      @recent_tags = Tagging::Tag.get_recent_tags_for_user(connection)
      @system_tags = Tagging::Tag.get_system_tags_for_user(connection)
      @custom_tags = Tagging::Tag.get_custom_tags_for_user(connection)
      @recommended_tags = connection.tag_keys.find(:all, :order => "tagging_tag_keys.created_at desc", :limit => 10)
    end
    respond_to do | format |
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
    end
  end

  def new
    @tag_types = Tagging::TagType.all
    @tag = Tagging::Tag.new
  end

  def create_multiple
    connection_ids = params[:connection_id].split(",").uniq unless params[:connection_id].blank?
    connection_ids.each do |connection_id|
      connection = Crm::Connection.find(params[:connection_id])
      Tagging::Tag.create_from_string(params[:tag_name], connection)
    end
    render :text => ''
  end

  def create
    unless params[:tag_name].blank?
      connection = Crm::Connection.find(params[:connection_id])
      Tagging::Tag.create_from_string(params[:tag_name], connection)
      if !params[:user_id].blank?
        user = Usage::User.find(params[:user_id])
        @tags = user.tags
        @recent_tags = user.tag_keys.find(:all, :order => "tagging_tag_keys.created_at desc", :limit => 5)
        @recommended_tags = user.tag_keys.find(:all, :order => "tagging_tag_keys.created_at desc", :limit => 10)
      elsif params[:connection_id]
        connection = Crm::Connection.find(params[:connection_id])
        @tags = connection.tags
        @recent_tags = connection.tag_keys.find(:all, :order => "tagging_tag_keys.created_at desc", :limit => 5)
        @recommended_tags = connection.tag_keys.find(:all, :order => "tagging_tag_keys.created_at desc", :limit => 10)
      end
    end
  end

  def search
    @search_tags = Tagging::TagKey.search(params[:search_tag])
    @tags = @search_tags
  end
end
