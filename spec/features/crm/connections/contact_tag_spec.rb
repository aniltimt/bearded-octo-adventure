require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'
require 'capybara/rails'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Create New tag" do

  before(:each) do
    Usage::User.delete_all
    Tagging::TagKey.delete_all
    Tagging::TagValue.delete_all
    Tagging::Tag.delete_all
    Crm::Connection.delete_all
    @user = FactoryGirl.create(:usage_user, :role_id =>1)
    created_connections_tag(3)
    request_login(@user)
  end

  it "should create tag with key value successfully", js:true do
    tag_key_value = Forgery::Name.first_name+"="+Forgery::Name.last_name
    submit_the_tag_form(tag_key_value,1,1,1)
  end
  
  it "should delete tag successfully", js:true do
    sleep 1
    tag_count = Tagging::Tag.count
    go_to_tag
    sleep 1
    find("#connection-tag-"+"#{Tagging::Tag.last.id}").click
    sleep 2
    Tagging::Tag.count.should eq(tag_count-1)
  end
  
  it "should create tag without value successfully", js:true do
    tag_key = Forgery::Basic.text
    submit_the_tag_form(tag_key,1,0,1)
    assert Tagging::Tag.last.tag_key_id.present?
    sleep 1
    assert Tagging::Tag.last.tag_value_id.blank?
  end
  
  it "should update tag and create tag value if tag key already exist in the db ", js:true do
    tag_key = Forgery::Basic.text
    tag_value = Forgery::Basic.text
    tag_key_value = tag_key+"="+tag_value
    create_tag_with_tag_key_only(1, @user, Crm::Connection.last, tag_key)
    assert Tagging::Tag.last.tag_value_id.blank?
    sleep 1
    submit_the_tag_form(tag_key_value,0,1,0)
    assert Tagging::Tag.last.tag_value_id.present?
  end
  
  it "should tag keys for the new tag already exist in the database", js:true do
    tag_key = Forgery::Basic.text
    create_tag_with_tag_key_only(1, @user, Crm::Connection.last, tag_key)
    sleep 1
    submit_the_tag_form(tag_key,0,0,0)
  end
  
  it "should not create new tag key and tag value for a connection if these are already exist in the db", js:true do
    tag_key = Forgery::Basic.text
    tag_value = Forgery::Basic.text
    tag_key_value = tag_key+"="+tag_value
    create_tag_with_tag_key_and_value(1, @user, Crm::Connection.last, tag_key, tag_value)
    sleep 1
    submit_the_tag_form(tag_key_value,0,0,0)
  end
  
  it "should not create a tag if tag value exist but the tag key doesn't", js:true do
    tag_value = "="+Forgery::Basic.text
    submit_the_tag_form(tag_value,0,0,0)
  end
  
  it "should not create tag if tag key and tag value are empty strings", js:true do
    tag_value = nil
    submit_the_tag_form(tag_value,0,0,0)   
  end
  
  def submit_the_tag_form(tag_name,count_key_increment=0,count_value_increment=0,count_tag_increment=0)
    tag_count = Tagging::Tag.count
    tag_key_count = Tagging::TagKey.count
    tag_value_count = Tagging::TagValue.count
    go_to_tag
    create_new_tag(tag_name)
    sleep 1
    Tagging::TagValue.count.should eq(tag_value_count+count_value_increment)
    Tagging::TagKey.count.should eq(tag_key_count+count_key_increment)
    Tagging::Tag.count.should eq(tag_count+count_tag_increment)
    click_on 'Client Management'
    within("#myTab") do
      click_on 'Contacts' 
      sleep 1
    end
  end 
 
  def go_to_tag
    click_on 'Contacts'
    within("#myTab") do
      click_on 'Contacts' 
    end
  end
  
  def create_new_tag(tag_key_value)
    sleep 1
    find(:css, "#check-box-"+"#{Crm::Connection.last.id}").set(true)
    click_on 'Tag'
    sleep 1
    fill_in 'tag_name', :with => tag_key_value
    sleep 1
    click_button 'Save tag'
    sleep 1
  end
   
  def created_connections(count=1)
    count.times do |i|
      FactoryGirl.create(:crm_connection_w_contact_info, :agent_id => @user.id)
    end
  end
  
  def created_connections_tag(count=1)
    count.times do |i|
      tagging_tag_type =  FactoryGirl.create(:tagging_tag_type)
      sleep 1
      crm_connection = FactoryGirl.create(:crm_connection_w_contact_info, :agent_id => @user.id)
      sleep 1
      tagging_tag = FactoryGirl.create(:tagging_tag_w_value, :user_id => @user.id, :connection_id => crm_connection.id.to_i,
       :tag_type_id => tagging_tag_type.id.to_i)
    end
  end

  def create_tag_with_tag_key_and_value(count, user=nil, connection = nil, tag_key, tag_value)
    count.times do |i|
      tag = FactoryGirl.create(:tagging_tag_w_value, :user_id => user.try(:id), :connection_id =>  connection.try(:id))
      tag.tag_key.update_attributes(:name => tag_key)
      tag.tag_value.update_attributes(:value => tag_value)
    end
  end

  def create_tag_with_tag_key_only(count, user=nil, connection = nil, tag_key)
    count.times do |i|
      tag = FactoryGirl.create(:tagging_tag_w_key, :user_id => user.try(:id), :connection_id =>  connection.try(:id))
      tag.tag_key.update_attributes(:name => tag_key)
    end
  end
end

