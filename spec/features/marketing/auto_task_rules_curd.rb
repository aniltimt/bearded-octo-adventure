require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'
require 'capybara/rails'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Create New Auto Task Rules" do

  before(:each) do
    Usage::User.destroy_all
    Marketing::AutoTaskRule.destroy_all
    @user = FactoryGirl.create(:usage_user, :role_id => 1)
    @marketing_campaign = FactoryGirl.create(:marketing_campaign, :owner_id => @user.id)
    @crm_auto_system_task_rule = FactoryGirl.create(:crm_auto_system_task_rule, :role_id => 2)
    request_login(@user)
  end

   it "should create auto task rule successfull", js:true do
    go_to_auto_task_rules
    click_link 'New Auto Task Rule'
    auto_task_rule_count = Marketing::AutoTaskRule.count
    fill_auto_task_rule
    click_button 'Save Task Rule'
    sleep 1
    Marketing::AutoTaskRule.count.should eq(auto_task_rule_count+1)
  end
  
  it "should edit update auto_task_rule successfully", js:true do
    create_marketing_auto_task_rule(4)
    marketing_auto_task_rule = Marketing::AutoTaskRule.first
    auto_task_rule_count = Marketing::AutoTaskRule.count
    go_to_auto_task_rules
    find("#edit-auto_task_rule-"+"#{marketing_auto_task_rule.id}").click
    fill_auto_task_rule
    click_button 'Update Task Rule'
    Marketing::AutoTaskRule.count.should eq(auto_task_rule_count)
  end
  
  it "should delete auto_task_rule successfully", js:true do
    create_marketing_auto_task_rule(5)
    sleep 1
    marketing_auto_task_rule = Marketing::AutoTaskRule.first
    auto_task_rule_count = Marketing::AutoTaskRule.count
    go_to_auto_task_rules
    sleep 1
    find("#delete-auto_task_rule-"+"#{marketing_auto_task_rule.id}").click
    sleep 1
    Marketing::AutoTaskRule.count.should eq(auto_task_rule_count-1)
  end
  
  def go_to_auto_task_rules
    click_on 'Marketing'
    within("#myTab") do
      click_on 'AutoTaskRule' 
    end
  end
  
  def create_marketing_auto_task_rule(count=1)
    count.times do |i|
      @crm_auto_system_task_rule1 = FactoryGirl.create(:crm_auto_system_task_rule, :role_id => 1)
      @marketing_campaign1 = FactoryGirl.create(:marketing_campaign, :owner_id => @user.id)
      @marketing_auto_task_rule = FactoryGirl.create(:marketing_auto_task_rule, :campaign_id => @marketing_campaign1.id, :auto_system_task_rule_id => @crm_auto_system_task_rule1.id)
    end
  end
    
  def  fill_auto_task_rule
    sleep 1
    fill_autocomplete "marketing_auto_task_rule_campaign_id", with: "#{@marketing_campaign.name}", select: "#{@marketing_campaign.name}"
    fill_autocomplete "marketing_auto_task_rule_auto_system_task_rule_id", with: "#{@crm_auto_system_task_rule.name}", select: "#{@crm_auto_system_task_rule.name}"
    sleep 1
  end
  
  def fill_autocomplete(field, options = {})
    fill_in field, :with => options[:with]

    page.execute_script %Q{ $('##{field}').trigger("focus") }
    page.execute_script %Q{ $('##{field}').trigger("keydown") }
    selector = "ul.ui-autocomplete a:contains('#{options[:select]}')"

    page.should have_selector selector
    page.execute_script "$(\"#{selector}\").mouseenter().click()"
  end
  
end
