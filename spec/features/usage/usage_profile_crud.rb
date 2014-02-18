require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'
require 'capybara/rails'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Create New profile" do

  before(:each) do
    Usage::User.destroy_all
    Usage::Profile.destroy_all
    @user = FactoryGirl.create(:usage_user, :role_id =>1)
    request_login(@user)
  end

   it "should create profile successfull", js:true do
    go_to_profile
    create_new_profile
  end
  
  it "should edit update profile successfully", js:true do
    create_usage_profile(4)
    sleep 1
    usage_profile = Usage::Profile.first
    profile_count = Usage::Profile.count
    go_to_profile

    find("#edit-profile-"+"#{usage_profile.id}").click
    fill_profile
    sleep 2
    find(:xpath, "//input[@id='profile-assign-to-user']").set "#{@user.full_name}"
    click_button 'Submit'
    sleep 1
    assert page.has_text?('Successfully updated')
    Usage::Profile.count.should eq(profile_count)
  end
  
  it "should delete profile successfully", js:true do
    create_usage_profile(5)
    sleep 1
    usage_profile = Usage::Profile.first
    profile_count = Usage::Profile.count
    go_to_profile

    find("#delete-profile-"+"#{usage_profile.id}").click
    page.driver.browser.switch_to.alert.accept
    sleep 1
    Usage::Profile.count.should eq(profile_count-1)
    assert page.has_text?('Successfully deleted')
    sleep 2
  end
 
  it "should assign profile to another user successfully", js:true do
    create_usage_profile
    go_to_profile
    @another_user = FactoryGirl.create(:usage_user)
    profile_user_count = Usage::ProfilesUser.count
    sleep 2
    assign_profile(@another_user)
    sleep 2
    assert page.has_text?('Successfully Assigned.')
    Usage::ProfilesUser.count.should eq(profile_user_count+1)
  end
  
  it "should assign profile to current user successfully", js:true do
    create_usage_profile 
    go_to_profile
    profile_user_count = Usage::ProfilesUser.count
    sleep 2
    assign_profile(@user)
    sleep 2
    assert page.has_text?(' Already assigned all profiles to selected user.')
    Usage::ProfilesUser.count.should eq(profile_user_count)
  end
  
  def create_new_profile
    click_link 'Create New Profile'
    profile_count = Usage::Profile.count
    fill_profile
    click_button 'Submit'
    sleep 2
    assert page.has_text?('Successfully created')
    Usage::Profile.count.should eq(profile_count+1)
  end
  
  def create_usage_profile(count=1)
    count.times do |i|
      @contact_info = FactoryGirl.create(:contact_info_w_assoc)
      @usage_profile = FactoryGirl.create(:usage_profile, :owner_id => @user.id, :contact_info_id => @contact_info.id)
      Usage::ProfilesUser.create(:profile_id => @usage_profile.id, :user_id => @user.id )
    end
  end
    
  def go_to_profile
    click_on 'Agency Management'
    within("#myTab") do
      click_on 'Profiles'  
    end
  end
  
  def  fill_profile
    fill_in 'contact_info[profile_attributes][name]', :with => Forgery::Name.full_name
    find_by_id('contact_info_profile_attributes_ownership_id').find("option[value='2']").click
    fill_in 'contact_info[company]', :with => Forgery::Name.company_name
    fill_in 'contact_info[emails_attributes][0][value]', :with => Forgery(:internet).email_address
    find_by_id('contact_info_phones_attributes_0_phone_type_id').find("option[value='3']").click
    fill_in 'contact_info[phones_attributes][0][value]', :with => Forgery(:address).phone
    fill_in 'contact_info[fax]', :with => rand(100000..999999)
    fill_in 'contact_info[addresses_attributes][0][value]', :with => Forgery(:address).street_address
    fill_in 'contact_info[city]', :with => Forgery(:address).city
    fill_in 'contact_info[state_id]', :with => Forgery(:address).state 
    fill_in 'contact_info[zip]', :with => Forgery(:address).zip
  end
  
  def assign_profile(user)
    my_box = find('#select-all-checkbox').set(false)
    unless my_box.present?
      click_button 'Assign'
      sleep 1
      page.driver.browser.switch_to.alert.accept
    end
    my_box = find('#select-all-checkbox').set(true)
    sleep 1
    click_button 'Assign'
    sleep 3
    fill_autocomplete "mass-assigning-profile", with: "#{user.full_name}", select: "#{user.full_name}"
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
