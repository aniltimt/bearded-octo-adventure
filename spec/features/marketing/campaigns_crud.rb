require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'
require 'capybara/rails'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Create New campaign" do

  before(:each) do
    Usage::User.destroy_all
    Marketing::Campaign.destroy_all
    @user = FactoryGirl.create(:usage_user)
    request_login(@user)
  end

   it "should create campaign successfull", js:true do
    go_to_campaign
    click_link 'Add New Campaign'
    campaign_count = Marketing::Campaign.count
    fill_campaign
    click_button 'Save Campaign'
    sleep 2
    Marketing::Campaign.count.should eq(campaign_count+1)
  end
  
  it "should edit update campaign successfully", js:true do
    create_marketing_campaign(4)
    sleep 1
    marketing_campaign = Marketing::Campaign.first
    campaign_count = Marketing::Campaign.count
    go_to_campaign
    find("#edit-campaign-"+"#{marketing_campaign.id}").click
    fill_campaign
    click_button 'Update Campaign'
    sleep 2
    Marketing::Campaign.count.should eq(campaign_count)
  end
  
  it "should delete campaign successfully", js:true do
    create_marketing_campaign(5)
    sleep 1
    marketing_campaign = Marketing::Campaign.first
    campaign_count = Marketing::Campaign.count
    go_to_campaign
    find("#delete-campaign-"+"#{marketing_campaign.id}").click
    sleep 1
    Marketing::Campaign.count.should eq(campaign_count-1)
    sleep 2
  end
  
  def go_to_campaign
    click_on 'Marketing'
    within("#myTab") do
      click_on 'Campaigns' 
    end
  end
  
  def create_marketing_campaign(count=1)
    count.times do |i|
      @marketing_campaign = FactoryGirl.create(:marketing_campaign, :owner_id => @user.id)
    end
  end
    
  def  fill_campaign
    find_by_id('marketing_campaign_ownership_id').find("option[value='3']").click
    fill_in 'marketing_campaign[name]', :with => Forgery::Name.first_name
  end
  
end

