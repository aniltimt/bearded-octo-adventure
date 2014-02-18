require 'spec_helper'

describe Crm::SystemTask do

  describe 'before_save create_activity callback' do
    it 'should create an Activity with field values corresponding to those of the task' do
      pending "Broken"
      task = FactoryGirl.create :crm_system_task
      activity = Crm::Activity.last
      activity.description.should eq task.label
      activity.owner_id.should eq task.assigned_to
    end

    it 'should create an Activity when changed to complete' do
      task = Crm::SystemTask.create
      task.completed_at = Time.now
      expect {
        task.save
      }.to change(Crm::Activity,:count).by(1)
      task.completed_at.should_not be nil
    end

    it 'should not create an Activity when it was already complete' do
      task = Crm::SystemTask.create
      task.completed_at = Time.now
      task.save
      task.label = 'foo'
      expect {
        task.save
      }.to change(Crm::Activity,:count).by(0)
      task.completed_at.should_not be nil
    end

    it 'should not create an Activity when not completed' do
      task = Crm::SystemTask.create
      task.label = 'foo'
      expect {
        task.save
      }.to change(Crm::Activity,:count).by(0)
      task.completed_at.should be nil
    end
  end
end
