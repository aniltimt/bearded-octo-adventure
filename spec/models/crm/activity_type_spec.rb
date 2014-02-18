require 'spec_helper'

shared_examples_for "has Crm::Accessible methods" do |klass, faktory|
  ACCESS_PERMUTATIONS = [[true, true],[true, false],[false, true],[false, false]]

  before :all do
    # create users
    @parent = FactoryGirl.create :usage_user
    @agent = FactoryGirl.create :usage_user, role_id:Usage::Role::AGENT_ID, parent:@parent
    @random = FactoryGirl.create :usage_user
    @child = FactoryGirl.create :usage_user, parent:@agent
    @grandchild = FactoryGirl.create :usage_user, parent:@child
    @sibling = FactoryGirl.create :usage_user, parent:@parent
    @nephew = FactoryGirl.create :usage_user, parent:@sibling
    # create resources
    @parent_resource = FactoryGirl.create faktory, agent:@parent
    @agent_resource = FactoryGirl.create faktory, agent:@agent
    @child_resource = FactoryGirl.create faktory, agent:@child
    @grandchild_resource = FactoryGirl.create faktory, agent:@grandchild
    @sibling_resource = FactoryGirl.create faktory, agent:@sibling
    @nephew_resource = FactoryGirl.create faktory, agent:@nephew
    @random_resource = FactoryGirl.create faktory, agent:@random
  end

  before :each do
    @agent.can_edit_siblings_resources =
    @agent.can_view_siblings_resources = 
    @agent.can_edit_nephews_resources =
    @agent.can_view_nephews_resources =
    @agent.can_edit_descendents_resources =
    @agent.can_view_descendents_resources =
    false
  end

  describe '#editable? and #viewable?' do
    describe 'agent' do
      it 'who owns it' do
        check_access @agent, @agent_resource, true, true
        check_access @agent, @random_resource, false, false
      end

      it 'whose sibling owns it' do
        ACCESS_PERMUTATIONS.each do |settings|
          @agent.can_edit_siblings_resources = settings[0]
          @agent.can_view_siblings_resources = settings[1]
          check_access @agent, @sibling_resource, settings[0], settings[1]
          check_access @agent, @random_resource, false, false
        end
      end

      it 'whose grandchild owns it' do
        ACCESS_PERMUTATIONS.each do |settings|
          @agent.can_edit_descendents_resources = settings[0]
          @agent.can_view_descendents_resources = settings[1]
          check_access @agent, @grandchild_resource, settings[0], settings[1]
          check_access @agent, @parent_resource, false, false
        end
      end

      it 'whose nephew owns it' do
        ACCESS_PERMUTATIONS.each do |settings|
          @agent.can_edit_nephews_resources = settings[0]
          @agent.can_view_nephews_resources = settings[1]
          check_access @agent, @nephew_resource, settings[0], settings[1]
          check_access @agent, @sibling_resource, false, false
        end
      end
    end

    describe 'support staff' do
      before :all do
        
      end
    end 
  end
end

describe Crm::ActivityType do
  pending "add some examples to (or delete) #{__FILE__}"
end