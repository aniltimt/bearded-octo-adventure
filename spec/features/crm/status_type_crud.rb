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
    @user = FactoryGirl.create(:usage_user)
    request_login(@user)
  end

  it "should create crm status type successfully" do
    status_type_count = Crm::StatusType.count
    create_new_status_type
    sleep 2
    status_type_latest_count = Crm::StatusType.count
    (status_type_latest_count - status_type_count).should eql 1
    within("#status-rules-left") do
      assert page.has_text?(Crm::StatusType.last.name)
    end
  end

  it "should update the crm status type successfully" do
    status_type = FactoryGirl.create(:crm_status_type, :owner_id => @user.id, :ownership_id => 1 + rand(2))
    status_type_count = Crm::StatusType.count
    sleep 2
    click_on "System Management"
    click_on "Status Rules"
    sleep 2
    find("#status_type_edit#{status_type.id}").click
    fill_and_submit_status_type_form
    status_type_latest_count = Crm::StatusType.count
    (status_type_latest_count - status_type_count).should eql 0
    within("#status-rules-left") do
      assert page.has_no_text?(status_type.name)
      assert page.has_text?(status_type.reload.name)
    end
  end

  def fill_and_submit_status_type_form
    fill_in 'crm_status_type[color]', :with => Forgery::Name.company_name
    fill_in 'crm_status_type[name]', :with => Forgery::Name.company_name
    fill_in 'crm_status_type[sort_order]', :with => rand(5)
    click_on "Save Status"
  end

  def create_new_status_type
    click_on "System Management"
    click_on "Status Rules"
    click_on "Add new Status type"
    fill_and_submit_status_type_form
  end
end
