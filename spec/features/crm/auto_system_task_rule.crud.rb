require 'support/feature_helpers.rb'
require 'support/request_helper.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Crm Status Type CRUD" do
  before(:each) do
    Usage::User.delete_all
    Crm::StatusType.delete_all
    Marketing::MessageMedia::Template.delete_all
    Marketing::Email::Template.delete_all
    Marketing::SnailMail::Template.delete_all
    @user = FactoryGirl.create(:usage_user)
    @status_type = FactoryGirl.create(:crm_status_type, :owner_id => @user.id, :ownership_id => 1 + rand(2))
    request_login(@user)
  end

  it "should create crm auto system task rule successfully if task type is nil(User)" do
    click_on "System Management"
    click_on "Status Rules"
    click_on @status_type.name
    (1..11).each do |i|
      count = Crm::AutoSystemTaskRule.count
      click_on "Add new auto system task rule"
      fill_auto_system_task_rule_form(i)
      sleep 2
      new_count = Crm::AutoSystemTaskRule.count
      (new_count - count).should eql 1
      new_record = Crm::AutoSystemTaskRule.last
      assert page.has_text?(new_record.name)
      assert page.has_text?(new_record.label)
      assert page.has_text?(new_record.name)
    end
  end

  it "should create crm auto system task rule successfully if task type is not nil" do
    create_email_templates(5)
    create_marketing_message_media_template(5)
    create_marketing_message_media_template(5)
    click_on "System Management"
    click_on "Status Rules"
    click_on @status_type.name
    Crm::SystemTaskType.all.each do |system_task_type|
      count = Crm::AutoSystemTaskRule.count
      click_on "Add new auto system task rule"
      fill_auto_system_task_rule_form(nil, system_task_type)
      sleep 2
      new_count = Crm::AutoSystemTaskRule.count
      (new_count - count).should eql 1
      new_record = Crm::AutoSystemTaskRule.last
      assert page.has_text?(new_record.name)
      assert page.has_text?(new_record.label)
      assert page.has_text?(new_record.name)
    end
  end

  def fill_auto_system_task_rule_form(role_id, system_task_type = nil)
    select(Usage::Role.find(role_id).try(:name), :from => 'crm_auto_system_task_rule[role_id]') unless role_id.blank?
    unless system_task_type.blank?
      select(system_task_type.name, :from => 'crm_auto_system_task_rule[task_type_id]')
      text = get_auto_complete_text(system_task_type)
      sleep 2
      fill_in 'crm_auto_system_task_rule_template_name', :with => text.blank? ? "tes" : text.slice(0..1)
      sleep 5
      find('.ui-menu-item', :text => text).click
    end
    fill_in 'crm_auto_system_task_rule[delay]', :with => 1 + rand(10)
    fill_in 'crm_auto_system_task_rule[label]', :with => Forgery::Name.company_name
    fill_in 'crm_auto_system_task_rule[name]', :with => Forgery::Name.company_name
    click_on "Create Auto system task rule"
  end
  
  def create_email_templates(count)
    Marketing::Membership.create(:owner_id => @user.id, :ownership_id => 1, :canned_template_privilege => true, :custom_template_privilege => true) 
    count.times { FactoryGirl.create(:marketing_email_template, :owner_id => @user.id, :name => Forgery::Name.company_name ) }
  end

  def create_marketing_snail_mail_templates(count)
    count.times { FactoryGirl.create(:marketing_snail_mail_template, :owner_id => @user.id, :name => Forgery::Name.company_name, :ownership_id => 1 ) }
  end

  def create_marketing_message_media_template(count)
    count.times { FactoryGirl.create(:marketing_message_media_template, :owner_id => @user.id, :name => Forgery::Name.company_name ) }
  end
  
  def get_auto_complete_text(system_task_type)
  
    if ["email", "email agent"].include?(system_task_type.name)
      return Marketing::Email::Template.all(@user).try(:first).try(:name)
    elsif ["phone dial", "phone broadcast", "sms", "sms agent"].include?(system_task_type.name)
      return Marketing::MessageMedia::Template.all(@user).try(:first).try(:name)
    elsif "letter" == system_task_type.name
      return Marketing::SnailMail::Template.all(@user).try(:first).try(:name)
    end
  end
end
