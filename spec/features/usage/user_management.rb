require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Create New user" do

  before(:each) do
    Usage::User.destroy_all
    @user = FactoryGirl.create(:usage_user)
    request_login(@user)
  end

  it "user must have can_have_children privilege to create new users", :js => true do
    go_to_create_child_page("#permission-box1")
    assert page.has_text?('You do not have permission to create user')
    permission_to_have_child(@user)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(1)
  end

  it "new user is a descendent of the user who created him/her" do
    permission_to_have_child(@user)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(1)
    @child_user = Usage::User.last
    @user.descendent_ids.include?(@child_user.id).should eq true
  end

  it "method 'ascendent_ids' should return child's all ancestor's ids" do
    permission_to_have_child(@user)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(1)
    @child_user1 = Usage::User.last
    permission_to_have_child(@child_user1)
    visit logout_path
    request_login(@child_user1)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(2)
    @child_user2 = Usage::User.last
    @child_user2.ascendent_ids.include?(@child_user1.id).should eq true
    @child_user2.ascendent_ids.include?(@user.id).should eq true
  end

  it "should be able to create child of child only if usage_user and it's child has can_have_children privilege" do
    permission_to_have_child(@user)
    permission_to_edit_decendents(@user)
    set_user_role(@user)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(1)
    @child_user = Usage::User.last
    click_on 'System Management'
    click_on @child_user.full_name
    new_user_page("#permission-box2")
    assert page.has_text?('You do not have permission to create user')
    click_on 'System Management'
    click_on @child_user.full_name
    permission_to_have_child(@child_user)
    new_user_page("#permission-box2")
    submit_create_user_form(3)
  end


  it "should be able to create child of child only if usage_user and it's child has can_have_children privilege" do
    permission_to_have_child(@user)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(1)
    @child_user = Usage::User.last
    go_to_create_child_page("#permission-box1")
    assert page.has_no_text?(@child_user.full_name)
    permission_to_edit_decendents(@user)
    click_on 'System Management'
    assert page.has_text?(@child_user.first_name)
  end

  it "all children in each search box should have same parent" do
    permission_to_have_child(@user)
    go_to_create_child_page("#permission-box1")
    submit_create_user_form(1)
    @child_user = Usage::User.last
    go_to_create_child_page("#permission-box1")
    assert page.has_no_text?(@child_user.full_name)
    permission_to_edit_decendents(@user)
    click_on 'System Management'
    assert page.has_text?(@child_user.first_name)
  end

  it "All children in each search box should have same parent" do
    permission_to_have_child(@user)
    permission_to_edit_decendents(@user)
    create_children(@user, 2)
    # create children, children of children, and children of children of children
    @user.children.each do |child|
      create_children(child, 3)
      child.children.each do |child_of_child|
        create_children(child_of_child, 3)
      end
    end
    # check parent of each children in each search box
    click_on 'System Management'
    @user.children.each do |child|
      within("#permission-box1") do
        assert page.has_text?(child.first_name)
        click_on child.first_name
      end
      child.children.each do |child_of_child|
        within("#permission-box2") do
          assert page.has_text?(child_of_child.first_name)
          click_on child_of_child.first_name
        end
        child_of_child.children.each do |leaf_child|
          within("#permission-box3") do
            assert page.has_text?(leaf_child.first_name)
          end
        end
      end
    end
  end

  it "anchor link in the right of each children should redirect to child's personal page" do
    permission_to_have_child(@user)
    permission_to_edit_decendents(@user)
    create_children(@user, 3)
    set_user_role(@user)
    click_on 'System Management'
    @user.children.each do |child|
      sleep 2
      find("#personal-link"+"#{child.id}").click
      assert page.has_text?('Personal')
      assert page.has_text?(child.first_name)
      assert page.has_text?(child.last_name)
      assert page.has_text?(child.login)
      click_on 'System Management'
    end
  end

  def go_to_create_child_page(permission_box)
    click_on 'System Management'
    new_user_page(permission_box)
  end

  def new_user_page(permission_box)
    within(permission_box) do
      click_on 'New User'
    end
  end

  def submit_create_user_form(count)
    fill_in 'contact_info[user_attributes][first_name]', :with => "test-firstname#{count}"
    fill_in 'contact_info[user_attributes][middle_name]', :with => "test-middlename#{count}"
    fill_in 'contact_info[user_attributes][last_name]', :with => "test-lastname#{count}"
    fill_in 'contact_info[user_attributes][login]', :with => "test-login#{count}"
    fill_in 'contact_info[user_attributes][password]', :with => "123456"
    fill_in 'contact_info[user_attributes][password_confirmation]', :with => "123456"
    page.find(:image,"[@name='commit']").click
    sleep 2
    assert page.has_text?('Account created.')
  end

  def permission_to_have_child(user)
    user.can_have_children = true
    user.can_edit_self = true
    user.can_edit_siblings = true
    user.save
  end

  def permission_to_edit_decendents(user)
    user.can_edit_descendents = true
    user.save
  end

  def create_children(user, count)
    count.times {FactoryGirl.create(:usage_user, :parent_id => user.id, :can_edit_descendents => true, :can_have_children => true )}
  end

  def set_user_role(user)
    user.role_id = 1
    user.save
  end
end
