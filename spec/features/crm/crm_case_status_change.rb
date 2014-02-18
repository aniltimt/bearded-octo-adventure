require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Crm Notes CRUD" do
  before(:each) do
    Usage::User.delete_all
    Crm::StatusType.delete_all
    Crm::AutoSystemTaskRule.delete_all
    Crm::Connection.delete_all
    Crm::Case.delete_all
    Crm::Status.delete_all
    Crm::SystemTask.delete_all
    @user = FactoryGirl.create(:usage_user, :can_have_children => true, :can_edit_descendents => true, :role_id => 1)
    create_status_types(@user, 5)
    create_auto_system_task_rules(@user, 5)
    create_connections(@user, 5)
    create_cases(@user, 5)
    request_login(@user)
  end

  it "should appear SystemTasks as they should in the Statuses#show view" do
    click_on "Client Management"
    create_system_tasks(@user, Crm::Case.all, 5)
    @user.crm_connections.each do |connection|
      click_on connection.full_name.slice(0..6)
      click_on "Policy"
      click_on "Follow up"
      Crm::StatusType.all(@user).each do |st|
        select(st.name, :from => 'crm_status_status_type_id')
        Crm::SystemTask.where(:status_id => connection.cases.first.status.id).each do |task|
          if task.task_type
            assert page.has_text?(task.task_type.name)
          end
          if task.marketing_email_template
            assert page.has_text?(task.marketing_email_template.name)
          end
        end
      end
      click_on "Client Management"
    end
  end

  it "When a StatusType which has never been chosen for the given Case is selected" do
    # a new Status created, and new SystemTasks are created for that status.
    # Each SystemTask must correspond to an AutoSystemTaskRule belonging to the Status.status_type.
    click_on "Client Management"
    create_system_tasks(@user, Crm::Case.all, 5)
    @user.crm_connections.each do |connection|
      click_on connection.full_name.slice(0..6)
      click_on "Policy"
      click_on "Follow up"
      new_status_type = Crm::StatusType.all(@user).last
      status_count = Crm::Status.count
      system_task_count = Crm::SystemTask.count
      select(new_status_type.name, :from => 'crm_status_status_type_id')
      sleep 2
      new_status_count = Crm::Status.count
      (new_status_count - status_count).should eql 1
      if new_status_type.auto_system_task_rules
        new_system_task_count = Crm::SystemTask.count
        (new_system_task_count - system_task_count).should eql new_status_type.auto_system_task_rules.count   
      end
      click_on "Client Management"
    end
  end

  # If 'auto system task rule' role is not nil and case's staff assignment has user with similar role to 'auto system task rule'
  it "should auto assign the system task to case's staff_assignment if auto system task rule has rol id and one of staff has the same role" do
    click_on "Client Management"
    @user.crm_connections.each do |connection|
      crm_case = connection.cases.first
      create_staff_assignment_for_case(crm_case)
      click_on connection.full_name.slice(0..6)
      click_on "Policy"
      click_on "Follow up"
      status_type = Crm::StatusType.all(@user).last
      crm_case.reload.status.system_tasks[0].assigned_to.should eql nil
      select(status_type.name, :from => 'crm_status_status_type_id')
      sleep 4
      system_task = Crm::SystemTask.where(:status_id => crm_case.reload.status.id).last
      crm_case.reload.staff_assignment.manager.should eql system_task.reload.assigned_to
      click_on "Client Management"
    end
  end

  # If 'auto system task rule' role is not nil and case.agent.staff_assignment has user with similar role to 'auto system task rule'  
  it "should auto assign the system task to case.agent's staff_assignment if auto system task rule has role id and one of staff has the same role" do
    click_on "Client Management"
    @user.crm_connections.each do |connection|
      crm_case = connection.cases.first
      create_staff_assignment_for_case_agent(crm_case)
      click_on connection.full_name.slice(0..6)
      click_on "Policy"
      click_on "Follow up"
      status_type = Crm::StatusType.all(@user).last
      crm_case.reload.status.system_tasks[0].assigned_to.should eql nil
      select(status_type.name, :from => 'crm_status_status_type_id')
      sleep 4
      system_task = Crm::SystemTask.where(:status_id => crm_case.reload.status.id).last
      crm_case.reload.staff_assignment.try(:manager).should_not eql system_task.reload.assigned_to
      crm_case.agent.reload.staff_assignment.manager.should eql system_task.reload.assigned_to
      click_on "Client Management"
    end
  end

  # If 'auto system task rule' role is not nil and case's staff assignment does not have user with similar role to 'auto system task rule' but case.connection.staff_assignment has
  it "should auto assign the system task to case.connection's staff_assignment if auto system task rule has role id and one of staff has the same role" do
    click_on "Client Management"
    @user.crm_connections.each do |connection|
      crm_case = connection.cases.first
      create_staff_assignment_for_case_connection(crm_case)
      click_on connection.full_name.slice(0..6)
      click_on "Policy"
      click_on "Follow up"
      status_type = Crm::StatusType.all(@user).last
      crm_case.reload.status.system_tasks[0].assigned_to.should eql nil
      select(status_type.name, :from => 'crm_status_status_type_id')
      sleep 4
      system_task = Crm::SystemTask.where(:status_id => crm_case.reload.status.id).last
      crm_case.reload.staff_assignment.try(:manager).should_not eql system_task.reload.assigned_to
      crm_case.agent.reload.staff_assignment.try(:manager).should_not eql system_task.reload.assigned_to
      crm_case.crm_connection.reload.staff_assignment.manager.should eql system_task.reload.assigned_to
      click_on "Client Management"
    end
  end

  # If 'auto system task rule' role is not nil and none case, case.agent and 
  it "should auto assign the system task to any user with the role similar to 'auto system task rule'" do
    click_on "Client Management"
    @user.crm_connections.each do |connection|
      crm_case = connection.cases.first      
      click_on connection.full_name.slice(0..6)
      click_on "Policy"
      click_on "Follow up"
      status_type = Crm::StatusType.all(@user).last
      crm_case.reload.status.system_tasks[0].assigned_to.should eql nil
      select(status_type.name, :from => 'crm_status_status_type_id')
      sleep 4
      system_task = Crm::SystemTask.where(:status_id => crm_case.reload.status.id).last
      crm_case.reload.staff_assignment.try(:manager).should_not eql system_task.reload.assigned_to
      crm_case.agent.reload.staff_assignment.try(:manager).should_not eql system_task.reload.assigned_to
      crm_case.crm_connection.reload.staff_assignment.try(:manager).should_not eql system_task.reload.assigned_to
      system_task.reload.assigned_to.role.should eql Usage::Role.find_by_name("manager")
      click_on "Client Management"
    end
  end

  it "When a Status Type which was chosen at some earlier time for the given Case is selected again" do
    click_on "Client Management"
    create_system_tasks(@user, Crm::Case.all, 5)
    connection = @user.crm_connections.first
    click_on connection.full_name.slice(0..6)
    click_on "Policy"
    click_on "Follow up"
    temp_status_type = old_status_type = connection.cases.first.status.status_type
    2.times do |i|
      if i == 0
        new_status_type = Crm::StatusType.all(@user).last
      else
        new_status_type = temp_status_type
      end
      sleep 2
      select(new_status_type.name, :from => 'crm_status_status_type_id')
      sleep 2
      changed_status_type = connection.cases.first.reload.status.status_type
      old_status_type.should_not eql changed_status_type
      new_status_type.should eql changed_status_type
      old_status_type = connection.cases.first.reload.status.status_type
    end
  end

  def create_status_types(user, count)
    count.times { FactoryGirl.create(:crm_status_type, :ownership_id => 1, :owner_id => user.id) }
  end

  def create_auto_system_task_rules(user ,count)
    status_types = Crm::StatusType.all(user)
    count.times do |i|
      FactoryGirl.create(:crm_auto_system_task_rule, :status_type_id => status_types[i].id, :role_id => Usage::Role.find_by_name("manager").id)
    end
  end

  def create_connections(user, count)
    count.times { FactoryGirl.create(:crm_connection, :agent_id => user.id, :connection_type_id => 3) }
  end

  def create_cases(user, count)
    connections = user.crm_connections
    agent_user = FactoryGirl.create(:usage_user)
    count.times do |i| 
      FactoryGirl.create(:crm_case, :connection_id => connections[i].id, :agent_id => agent_user.id)
    end
    usage_user = FactoryGirl.create(:usage_user, :can_have_children => true, :can_edit_descendents => true, :role_id => Usage::Role.find_by_name("manager").id)
  end

  def create_system_tasks(user, crm_cases, count)
    count.times do |i|
      FactoryGirl.create(:crm_system_task, :created_by => user.id.to_i, :connection_id => crm_cases[i].crm_connection.id, :status_id => crm_cases[i].status_id, :completed_at => nil )
    end 
  end

  def create_staff_assignment_for_case(crm_case)
    usage_staff_assignment = create_staff_assignment
    crm_case.staff_assignment_id = usage_staff_assignment.id
    crm_case.save
  end

  def create_staff_assignment_for_case_agent(crm_case)
    usage_staff_assignment = create_staff_assignment
    crm_case.agent.staff_assignment_id = usage_staff_assignment.id
    crm_case.agent.save
    crm_case.save
  end

  def create_staff_assignment_for_case_connection(crm_case)
    usage_staff_assignment = create_staff_assignment
    crm_case.crm_connection.staff_assignment_id = usage_staff_assignment.id
    crm_case.crm_connection.save
    crm_case.save
  end

  def create_staff_assignment
    usage_user1 = FactoryGirl.create(:usage_user, :role_id => Usage::Role.find_by_name("manager").id)
    usage_user2 = FactoryGirl.create(:usage_user, :role_id => Usage::Role.find_by_name("case manager").id)
    usage_staff_assignment = FactoryGirl.create(:usage_staff_assignment, :case_manager_id => usage_user2.id, :manager_id => usage_user1.id)
    return usage_staff_assignment 
  end

  def create_usage_users( count )
    count.times { FactoryGirl.create(:usage_user) }
  end

end
