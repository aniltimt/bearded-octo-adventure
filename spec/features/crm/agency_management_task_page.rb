require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Crm System Tasks" do
  before(:each) do
    Usage::User.delete_all
    Crm::Case.delete_all
    Crm::Connection.delete_all
    Crm::SystemTask.delete_all
    Crm::Status.delete_all
    @user = FactoryGirl.create(:usage_user)
    request_login(@user)
  end

  describe "agency management>tasks page" do

    before(:each) do
      create_crm_connections(@user, 5)
      create_crm_cases(@user, @user.crm_connections, 5)
      create_system_tasks_incomplete(@user, Crm::Case.all, 5)
      create_system_tasks_complete(@user, Crm::Case.all, 5)
    end

    it "the completed task should display in 'Completed' section and in-completed tasks should display under 'To Do'  section" do
      click_on "Agency Management"
      click_on "Tasks"
      within("#user-incomplete-tasks-container") do
        @user.crm_system_tasks.where("completed_at IS ?", nil).each do |system_task|
          assert page.has_text?(system_task.crm_connection.try(:full_name))
        end
      end
      within("#user-completed-tasks-container") do
        @user.crm_system_tasks.where("completed_at IS NOT ?", nil).each do |system_task|
          assert page.has_text?(system_task.crm_connection.try(:full_name))
        end
      end
    end

    it "by completing a task via checking the checkbox in the right, the task description should move in under completed tasks" do
      click_on "Agency Management"
      click_on "Tasks"
      system_task = @user.crm_system_tasks.where("completed_at IS ?", nil).first
      within("#user-incomplete-tasks-container") do
        find("#change-task-status-#{system_task.id}").click
      end
      within("#user-completed-tasks-container") do
        assert page.has_text?(system_task.crm_connection.try(:full_name))
      end
    end

    it "by changing the status via uncheck the checkbox in the right, the task description should move under To do list" do
      click_on "Agency Management"
      click_on "Tasks"
      system_task = @user.crm_system_tasks.where("completed_at IS NOT ?", nil).first
      within("#user-completed-tasks-container") do
        find("#change-task-status-#{system_task.id}").click
      end
      within("#user-incomplete-tasks-container") do
        assert page.has_text?(system_task.crm_connection.try(:full_name))
      end    
    end

    it "should search in the incomplete tasks via first name & last name of staff or recipient" do
      click_on "Agency Management"
      click_on "Tasks"
      system_task = @user.crm_system_tasks.where("completed_at IS ?", nil).first
      not_searched_tasks = @user.crm_system_tasks.where("completed_at IS ?", nil) - [system_task]
      2.times do |i|
        if i==0
          fill_in 'input-search-user-incomplete-tasks', :with => system_task.crm_connection.first_name
        else
          fill_in 'input-search-user-incomplete-tasks', :with => system_task.crm_connection.last_name
        end
        find("#button-search-user-incomplete-tasks").click
        within("#user-incomplete-tasks-container") do
          not_searched_tasks.each do |sys_task|
            assert page.has_no_text?(sys_task.crm_connection.try(:full_name))
          end
          assert page.has_text?(system_task.crm_connection.try(:full_name))
        end
      end
    end

    it "should search in the completed tasks via first name & last name of staff or recipient" do
      click_on "Agency Management"
      click_on "Tasks"
      system_task = @user.crm_system_tasks.where("completed_at IS NOT ?", nil).first
      not_searched_tasks = @user.crm_system_tasks.where("completed_at IS NOT ?", nil) - [system_task]
      2.times do |i|
        if i==0
          fill_in 'input-search-user-completed-tasks', :with => system_task.crm_connection.first_name
        else
          fill_in 'input-search-user-completed-tasks', :with => system_task.crm_connection.last_name
        end
        find("#button-search-user-completed-tasks").click
        within("#user-completed-tasks-container") do
          not_searched_tasks.each do |sys_task|
            assert page.has_no_text?(sys_task.crm_connection.try(:full_name))
          end
          assert page.has_text?(system_task.crm_connection.try(:full_name))
        end
      end
    end
    
    it "all in-completed tasks should display on model page in to do list" do
      within("#rightbar") do
        page.execute_script('$("ul li:nth-child(1)").trigger("click")')
      end
      within("#container-rightbar-nav") do
        system_tasks = @user.crm_system_tasks.where("completed_at IS ?", nil)
        system_tasks.each do |sys_task|
          assert page.has_no_text?(sys_task.crm_connection.try(:full_name))
        end
      end
    end

  end

  def create_system_tasks_incomplete(user, crm_cases, count)
    count.times do |i|
      FactoryGirl.create(:crm_system_task, :created_by => user.id.to_i, :connection_id => crm_cases[i].crm_connection.id, :status_id => crm_cases[i].status_id, :completed_at => nil )
    end 
  end
  
  def create_crm_connections(agent, count)
    count.times do |i|
      FactoryGirl.create(:crm_connection, :agent_id => @user.id, :connection_type_id => 3)
    end
  end
  
  def create_crm_cases(agent, crm_connections, count)
    count.times do |i|
      FactoryGirl.create(:crm_case, :owner_id => agent.id, :connection_id => crm_connections[i].id)
    end
  end

  def create_system_tasks_complete(user, crm_cases, count)
    count.times do |i|
      FactoryGirl.create(:crm_system_task, :created_by => user.id.to_i, :connection_id => crm_cases[i].crm_connection.id, :status_id => crm_cases[i].status_id)
    end
  end

end
