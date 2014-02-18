require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Crm Activities" do
  before(:each) do
    Usage::User.delete_all
    Crm::Connection.delete_all
    Crm::Activity.delete_all
    @user = FactoryGirl.create(:usage_user)
    request_login(@user)
  end

=begin
  it "should manually create activity" do
    count = Crm::Activity.count
    create_new_activity
    sleep 2
    assert page.has_text?('Successfully created')
    Crm::Activity.count.should eq(count+1)
  end
=end

  it "should delete note successfully" do
    create_activity
    last_activity = Crm::Activity.last
    click_on 'Agency Management'
    sleep 1
    find("#delete-activity#{last_activity.id}").click
    page.driver.browser.switch_to.alert.accept
    sleep 2
    assert page.has_text?('Successfully Deleted.')
    Crm::Activity.count.should eq(@count-1)
  end

  it "should create activity when Task completed and displayed on activities#index page" do
    create_activity
    click_on 'Agency Management'
    last_activity = Crm::Activity.last
    assert page.has_text?(last_activity.created_at.to_date)
    assert page.has_text?(last_activity.created_at.strftime("%H:%M %P"))
  end

  def create_activity
    @crm_connection = FactoryGirl.create(:crm_connection, :agent_id => @user.id)
    @crm_case = FactoryGirl.create(:crm_case, :agent_id => @user.id,
                :connection_id=>@crm_connection.id)
    @system_task = FactoryGirl.create(:crm_system_task, :status_id => @crm_case.status_id,
                    :created_by=>@user.id, :completed_at=>nil)
    prev_count = Crm::Activity.count
    click_on 'Dashboard'
    find("#change-task-status-#{@system_task.id}").click
    sleep 1
    @count = Crm::Activity.count
    @count.should eq(prev_count+1)
  end
end
