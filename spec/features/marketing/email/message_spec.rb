require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Marketing Message" do
  before(:each) do
    Usage::User.delete_all
    Marketing::Membership.delete_all
    Crm::Connection.delete_all
    Marketing::Email::Message.delete_all
    Marketing::Email::SmtpServer.delete_all
    Marketing::Email::Template.delete_all
    @user = FactoryGirl.create(:usage_user)
    @crm_connection = FactoryGirl.create(:crm_connection_w_assoc, :agent_id => @user.id)
    @membership = FactoryGirl.create(:marketing_membership, :owner_id => @user.id)
    @smtp_server = FactoryGirl.create(:marketing_email_smtp_server, owner_id: @user.id)
    @template = FactoryGirl.create(:marketing_email_template, owner_id: @user.id)
    request_login(@user)
  end

  it "should create marketing message" do
    count = Marketing::Email::Message.count
    create_new_marketing_message
    click_on 'Submit'
    sleep 5
    assert page.has_text?('Created successfully.')
    @message = @user.email_messages.last
    assert page.has_text?(@message.id)
    Marketing::Email::Message.count.should eq(count+1)
  end

  it "should edit existing marketing message" do
    create_marketing_message(5)
    sleep 5
    go_to_marketing_email_message
    count = Marketing::Email::Message.count
    @message = @user.email_messages.first
    edit_marketing_message
    assert page.has_text?(@message.id)
    Marketing::Email::Message.count.should eq(count)
  end

  it "should not send existing marketing message if no reciever" do
    FactoryGirl.create(:marketing_email_message, sender_id: @user.id, user_id: nil,
        connection_id: nil, template_id: nil, recipient: nil)
    sleep 1
    go_to_marketing_email_message
    @message = @user.email_messages.last
    assert page.has_text?(@message.id)
    find("#message#{@message.id} a.send_message").click
    sleep 2
    assert page.has_text?('Not sent because any of your receiver does not have email address.')
  end

  it "should send existing marketing message if smtp server settings is invalid" do
    create_marketing_message
    sleep 1
    @message = @user.email_messages.last
    go_to_marketing_email_message
    sleep 1
    assert page.has_text?(@message.id)
    find("#message#{@message.id} a.send_message").click
    sleep 2
    assert page.has_text?('Something is wrong with your smtp setting.')
  end

  it "should send existing marketing message" do
    create_marketing_message
    sleep 1
    @message = @user.email_messages.last
    go_to_marketing_email_message
    sleep 1
    assert page.has_text?(@message.id)
    update_smtp_server_settings
    find("#message#{@message.id} a.send_message").click
    sleep 10
    assert page.has_text?('Email message sent successfully.')
  end

  it "should not send newely created marketing message if smtp settings invalid" do
    count = Marketing::Email::Message.count
    create_new_marketing_message
    click_on 'Send'
    sleep 10
    @message = @user.email_messages.last
    assert page.has_text?('Something is wrong with your smtp setting.')
    assert page.has_text?(@message.id)
    Marketing::Email::Message.count.should eq(count+1)
  end

  it "should not send newely created marketing message if no reciever" do
    count = Marketing::Email::Message.count
    go_to_marketing_email_message
    click_on 'New Email Message'
    sleep 1
    fill_in 'marketing_email_message[subject]', :with => Forgery::Name.company_name
    page.execute_script('$("#marketing_email_message_body").tinymce().setContent("This is the body.")')
    click_on 'Send'
    sleep 10
    @message = @user.email_messages.last
    assert page.has_text?('Successfully created but not sent because any of your receiver does not have email address.')
    assert page.has_text?(@message.id)
    Marketing::Email::Message.count.should eq(count+1)
  end

  it "should send newely created marketing message" do
    count = Marketing::Email::Message.count
    update_smtp_server_settings
    create_new_marketing_message
    click_on 'Send'
    sleep 10
    @message = @user.email_messages.last
    assert page.has_text?('Email message sent successfully.')
    assert page.has_text?(@message.id)
    Marketing::Email::Message.count.should eq(count+1)
  end

  def go_to_marketing_email_message
    click_on 'Marketing'
    click_on 'Email Messages'
  end

  def create_marketing_message(count=1)
    count.times do |i|
      FactoryGirl.create(:marketing_email_message, sender_id: @user.id, user_id: @user.id,
        connection_id: @crm_connection.id, template_id: @template.id)
    end
  end

  def create_new_marketing_message
    go_to_marketing_email_message
    click_on 'New Email Message'
    sleep 2
    fill_marketing_message_form
  end

  def edit_marketing_message
    find("#message#{@message.id} a.edit_message").click
    sleep 1
    fill_marketing_message_form
    click_on 'Submit'
    sleep 2
    assert page.has_text?('Updated successfully.')
  end

  def fill_marketing_message_form
    fill_in 'marketing_email_message[recipient]', :with => Forgery(:internet).email_address
    fill_autocomplete "crm-connection-for-liquid", with: "#{@crm_connection.full_name}", select: "#{@crm_connection.full_name}"
    fill_autocomplete "usage-user-for-liquid", with: "#{@user.full_name}", select: "#{@user.full_name}"
    fill_in 'marketing_email_message[subject]', :with => Forgery::Name.company_name
    page.execute_script('$("#marketing_email_message_body").tinymce().setContent("This is the body.")')
  end

  def fill_autocomplete(field, options = {})
    fill_in field, :with => options[:with]

    page.execute_script %Q{ $('##{field}').trigger("focus") }
    page.execute_script %Q{ $('##{field}').trigger("keydown") }
    selector = "ul.ui-autocomplete a:contains('#{options[:select]}')"

    page.should have_selector selector
    page.execute_script "$(\"#{selector}\").mouseenter().click()"
  end

  def update_smtp_server_settings
    #======= Need to add valid credentials========================
    @smtp_server.update_attributes(address: "smtp.gmail.com",
      username: "test@mailinator.com", password: "123456", port: 587)
    #=============================================================
  end
end
