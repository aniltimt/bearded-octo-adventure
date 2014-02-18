require 'spec_helper'

describe Tagging::Tag do

  before(:each) do
    Usage::User.delete_all
    Tagging::Tag.delete_all
    Tagging::TagKey.delete_all
    Tagging::TagValue.delete_all
    Crm::Connection.delete_all
  end

  describe "::create_from_string behavior" do

    before(:each) do
      @user = FactoryGirl.create(:usage_user)
      @connection = FactoryGirl.create(:crm_connection, :agent_id => @user.id)
    end

    it "::create_from_string should create key, value and tag for a connection and passed string" do
      tag_count = Tagging::Tag.count
      tag_key_count = Tagging::TagKey.count
      tag_value_count = Tagging::TagValue.count
      Tagging::Tag.create_from_string(Forgery::Basic.text+"="+Forgery::Basic.text, @connection)
      new_tag_count = Tagging::Tag.count
      new_tag_key_count = Tagging::TagKey.count
      new_tag_value_count = Tagging::TagValue.count
      (new_tag_value_count - tag_value_count).should eql 1
      (new_tag_key_count - tag_key_count).should eql 1
      (new_tag_count - tag_count).should eql 1
    end

    it "::create_from_string should not create duplicate tag_key, tag_value, and tag" do
      string = Forgery::Basic.text+"="+Forgery::Basic.text
      Tagging::Tag.create_from_string(string, @connection)
      tag_count = Tagging::Tag.count
      tag_key_count = Tagging::TagKey.count
      tag_value_count = Tagging::TagValue.count
      Tagging::Tag.create_from_string(string, @connection)
      new_tag_count = Tagging::Tag.count
      new_tag_key_count = Tagging::TagKey.count
      new_tag_value_count = Tagging::TagValue.count
      (new_tag_value_count - tag_value_count).should eql 0
      (new_tag_key_count - tag_key_count).should eql 0
      (new_tag_count - tag_count).should eql 0
    end

    it "::create_from_string should not create tag_value if string format is %s" do
      tag_value_count = Tagging::TagValue.count
      Tagging::Tag.create_from_string(Forgery::Basic.text, @connection)
      new_tag_value_count = Tagging::TagValue.count
      (new_tag_value_count - tag_value_count).should eql 0
    end

    it "::create_from_string should create tag_key and tag_value if string format is %s=%s" do
      string1 = Forgery::Basic.text
      string2 = Forgery::Basic.text
      string  = string1+"="+string2
      Tagging::Tag.create_from_string(string, @connection)
      Tagging::TagKey.last.name.should eql string1
      Tagging::TagValue.last.value.should eql string2
    end

    it "::create_from_string should accept the tag value with white space" do
      string1 = Forgery::Basic.text
      string2 = Forgery::Basic.text+" "+Forgery::Basic.text
      string  = string1+"="+string2
      Tagging::Tag.create_from_string(string, @connection)
      Tagging::TagValue.last.value.should eql string2
    end

    it "::create_from_string should accept the tag key with white space" do
      string1 = Forgery::Basic.text+" "+Forgery::Basic.text
      string2 = Forgery::Basic.text
      string  = string1+"="+string2
      Tagging::Tag.create_from_string(string, @connection)
      Tagging::TagKey.last.name.should eql string1
    end
  end

  it "should return tag key name" do
    @tag = FactoryGirl.create(:tagging_tag_w_key)
    @tag.key.should eql @tag.tag_key.name
  end

  it "should create the tag key for a tag with passing tag key name if tag key is not exist already (with or without owner)" do
    @tag = FactoryGirl.create(:tagging_tag)
    tag_key_count = Tagging::TagKey.count
    string = Forgery::Basic.text
    @tag.key= string
    new_tag_key_count = Tagging::TagKey.count
    (new_tag_key_count - tag_key_count).should eql 1
    @tag.key= string
    check_duplicate_key_count = Tagging::TagKey.count
    (check_duplicate_key_count - new_tag_key_count).should eql 0
  end

  it "should return tag value value" do
    @tag = FactoryGirl.create(:tagging_tag_w_value)
    @tag.value.should eql @tag.tag_value.value
  end

  it "should create the tag value for a tag with passing tag value value if tag value is not exist already" do
    @tag = FactoryGirl.create(:tagging_tag)
    tag_value_count = Tagging::TagValue.count
    string = Forgery::Basic.text
    @tag.value= string
    new_tag_value_count = Tagging::TagValue.count
    (new_tag_value_count - tag_value_count).should eql 1
    @tag.value= string
    check_duplicate_value_count = Tagging::TagValue.count
    (check_duplicate_value_count - new_tag_value_count).should eql 0
  end

  it "should retuen tag key name and tag value value if tag value is not nil otherwise return tag key name only" do
    @tag = FactoryGirl.create(:tagging_tag_w_key)
    @tag.to_s.should eql @tag.tag_key.name
    @tag = FactoryGirl.create(:tagging_tag_w_value)
    @tag.to_s.should eql "#{@tag.tag_key.name}=#{@tag.tag_value.value}"
  end

  it "should return latest five tags for which tag key exist" do
    user = FactoryGirl.create(:usage_user)
    create_tag_with_tag_key(10, user)
    result = Tagging::Tag.get_recent_tags_for_user(user)
    recent_tags_with_tag_key = Tagging::Tag.joins(:tag_key).where("tagging_tags.user_id = ?", user.id).limit(5).order('created_at desc')
    recent_tags_with_tag_key.size.should eql 5
    result === recent_tags_with_tag_key
  end

  it "should return all system tags" do
    user = FactoryGirl.create(:usage_user)
    create_tag_with_tag_key(10, user)
    create_tag_with_tag_key_with_owner(10, user)
    result = Tagging::Tag.get_recent_tags_for_user(user)
    recent_system_tags_with_tag_key = Tagging::Tag.joins(:tag_key).where("tagging_tags.user_id = ? and tagging_tag_keys.owner_id is null", user.id).limit(5).order('created_at desc')
    recent_system_tags_with_tag_key.size.should eql 5
    result === recent_system_tags_with_tag_key
  end

  it "should return recent custom tags of user" do
    user = FactoryGirl.create(:usage_user)
    create_tag_with_tag_key(10, user)
    create_tag_with_tag_key_with_owner(10, user)
    result = Tagging::Tag.get_custom_tags_for_user(user)
    recent_custom_tags_with_tag_key = Tagging::Tag.joins(:tag_key).where("tagging_tags.user_id = ? and tagging_tag_keys.owner_id is not null", user.id).limit(5).order('created_at desc')
    recent_custom_tags_with_tag_key.size.should eql 5
    result === recent_custom_tags_with_tag_key
  end

  it "should return recent tags for connection" do
    user = FactoryGirl.create(:usage_user)
    connection = FactoryGirl.create(:crm_connection, :agent_id => user.id)
    create_tag_with_tag_key(10, user, connection)
    create_tag_with_tag_key(10, user)
    result = Tagging::Tag.get_recent_tags_for_connection(connection)
    recent_tags_for_connection = Tagging::Tag.joins(:tag_key).where("tagging_tags.connection_id = ?", connection.id).limit(5).order('created_at desc')
    recent_tags_for_connection.size.should eql 5
    result === recent_tags_for_connection
  end

  it "should return recent system tags for connection" do
    user = FactoryGirl.create(:usage_user)
    connection = FactoryGirl.create(:crm_connection, :agent_id => user.id)
    create_tag_with_tag_key(10, user, connection)
    create_tag_with_tag_key_with_owner(10, user)
    result = Tagging::Tag.get_system_tags_for_connection(connection)
    recent_system_tags_for_connection = Tagging::Tag.joins(:tag_key).where("tagging_tags.connection_id = ? and tagging_tag_keys.owner_id is null", connection.id).limit(5).order('created_at desc')
    recent_system_tags_for_connection.size.should eql 5
    result === recent_system_tags_for_connection
  end

  it "should return recent custom tags for connection" do
    user = FactoryGirl.create(:usage_user)
    connection = FactoryGirl.create(:crm_connection, :agent_id => user.id)
    create_tag_with_tag_key_with_owner(10, user, connection)
    create_tag_with_tag_key_with_owner(10, user)
    result = Tagging::Tag.get_custom_tags_for_connection(connection)
    recent_custom_tags_for_connection = Tagging::Tag.joins(:tag_key).where("tagging_tags.connection_id = ? and tagging_tag_keys.owner_id is not null", connection.id).limit(5).order('created_at desc')
    recent_custom_tags_for_connection.size.should eql 5
    result === recent_custom_tags_for_connection
  end

  it "should return all tags whose tag key name is 'lead type' and tag value is not null" do
    create_tag_with_key_and_value(10)
    result = Tagging::Tag.lead_types
    all_tags_with_tag_key_lead_type = Tagging::Tag.joins(:tag_key).joins(:tag_value).where('tagging_tag_keys.name = ?','lead type').where('tag_value_id is not null')
    all_tags_with_tag_key_lead_type.size.should eql 10
    result === all_tags_with_tag_key_lead_type
  end

  private

  def create_tag_with_tag_key(count, user=nil, connection =nil)
    count.times { FactoryGirl.create(:tagging_tag_w_key, :user_id => user.try(:id), :connection_id => connection.try(:id)) }
  end

  def create_tag_with_tag_key_with_owner(count, user=nil, connection = nil)
    count.times do |i|
      tag = FactoryGirl.create(:tagging_tag_w_key, :user_id => user.try(:id), :connection_id =>  connection.try(:id))
      tag_key = tag.tag_key
      tag_key.owner_id = user.id
      tag_key.save
    end
  end

  def create_tag_with_key_and_value(count)
    user = FactoryGirl.create(:usage_user)
    count.times do
      connection = FactoryGirl.create(:crm_connection, :agent_id => user.id)
      string = "lead type="+Forgery::Basic.text
      Tagging::Tag.create_from_string(string, connection)
    end
  end

end
