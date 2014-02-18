require 'spec_helper'
require 'support/data_helper'
RSpec.configure do |config|
  config.include DataHelper
  Delayed::Worker.delay_jobs = false
end

viewables = []

describe Usage::User do

  it "should respond for all attributes" do
    user = FactoryGirl.build(:usage_user)
    [ :agent_field_set_id, :agent_of_record_id, :commission_level_id,
      :contact_info_id, :current_login_at, :current_login_ip, :crypted_password,
      :enabled, :failed_login_count, :last_login_at, :last_login_ip, :last_request_at,
      :login_count, :login, :manager_id, :note, :parent_id, :role_id, :sales_support_field_set_id,
      :staff_assignment_id
    ].each do |attr|
      user.should respond_to(attr)
    end
    [ :agent_field_set, :agent_of_record, :commission_level, :contact_info, :manager, :parent, :sales_support_field_set, :selected_profile, :staff_assignment, :role
      ].each do |attr|
      user.should belong_to(attr)
    end
  end
    
  describe 'agents scope' do
    it 'should return only and all agents' do
      pending
    end
  end
  
  describe 'licensed scope' do
    it 'should return only and all licensed users for given state' do
      pending
    end
  end
  
  describe 'children_of scope' do
    it 'should return only and all children_of given user/group' do
      pending
    end
  end
  
  describe 'for_premium_limit scope' do
    it 'should return only and all users elligible for premium limit for given lead type' do
      pending
    end
  end

  describe 'available scope' do
    it 'should return only and all users who are not AFK' do
      pending
    end
  end

  describe 'countdown_positive scope' do
    it 'should return only and all users who have a positive countdown for given lead type' do
      pending
    end
  end

  describe 'not_suspended scope' do
    it 'should return only and all users who have a null temporary_suspension' do
      pending
    end
  end

  describe 'self.agent_for_assignment' do
    it '' do
      pending
    end
  end

  describe 'saving' do
    context 'creates ascendent associations' do
      before :all do
        @gparent = FactoryGirl.create :usage_user
        @parent = FactoryGirl.create :usage_user, parent:@gparent
      end

      context 'for self' do
        it 'on new record' do
          user = FactoryGirl.create :usage_user, parent:@parent
          user.ascendents.should include @parent
          user.ascendents.should include @gparent
        end

        it 'on existing record' do
          user = FactoryGirl.create :usage_user, parent_id:nil
          user.ascendents.should be_empty
          user.update_attributes parent_id:@parent.id
          ascendent_ids = user.ascendents.select(:id).map(&:id)
          ascendent_ids.should include @parent.id
          ascendent_ids.should include @gparent.id
        end
      end

      it 'for children' do
        user = FactoryGirl.create :usage_user
        child1 = FactoryGirl.create :usage_user, parent:user
        child2 = FactoryGirl.create :usage_user, parent:user
        gchild = FactoryGirl.create :usage_user, parent:child2
        user.update_attributes parent_id:@parent.id
        pending "user must have parent" if user.parent.nil?
        pending "user must have children" if user.children.empty?
        [child1, child2, gchild].each { |descendent|
          descendent.reload # must reload so that child can get ascendents correctly
          ascendent_ids = descendent.ascendents.select(:id).map(&:id)
          ascendent_ids.should include(user.id), "user #{user.id} not included among ascendents #{ascendent_ids.inspect} for descendent #{descendent.id}"
          ascendent_ids.should include(@parent.id), "parent #{@parent.id} not included among ascendents #{ascendent_ids.inspect} for descendent #{descendent.id}"
          ascendent_ids.should include(@gparent.id), "gparent #{@gparent.id} not included among ascendents #{ascendent_ids.inspect} for descendent #{descendent.id}"
        }
      end

      it 'unless parent_id has not changed' do
        user = FactoryGirl.create :usage_user, parent:@parent
        user.should_not_receive(:_update_ascendent_associations)
        user.update_attributes birth:30.years.ago
      end
    end
  end
end
