require 'spec_helper'

shared_examples_for "Crm::Accessible" do |klass, faktory|
  let(:access_permutations) {[[true, true],[true, false],[false, true],[false, false]]}

  before :all do
    @klass = klass
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
        access_permutations.each do |settings|
          @agent.can_edit_siblings_resources = settings[0]
          @agent.can_view_siblings_resources = settings[1]
          check_access @agent, @sibling_resource, settings[0], settings[1]
          check_access @agent, @random_resource, false, false
        end
      end

      it 'whose grandchild owns it' do
        access_permutations.each do |settings|
          @agent.can_edit_descendents_resources = settings[0]
          @agent.can_view_descendents_resources = settings[1]
          check_access @agent, @grandchild_resource, settings[0], settings[1]
          check_access @agent, @parent_resource, false, false
        end
      end

      it 'whose nephew owns it' do
        access_permutations.each do |settings|
          @agent.can_edit_nephews_resources = settings[0]
          @agent.can_view_nephews_resources = settings[1]
          check_access @agent, @nephew_resource, settings[0], settings[1]
          check_access @agent, @sibling_resource, false, false
        end
      end
    end

    describe 'support staff' do
      before :all do
        @kase = FactoryGirl.create faktory, agent:@agent
        @staff_assignment = FactoryGirl.create :usage_staff_assignment_w_assoc, agent:@agent
      end

      it 'who is assigned to agent' do
        random_staff_assignment = FactoryGirl.create :usage_staff_assignment_w_assoc, agent:@random
        [:administrative_assistant, :case_manager, :sales_assistant, :sales_coordinator, :sales_support].each{ |role_name|
          user = @staff_assignment.send(role_name)
          check_access user, @kase, true, true
          rand_user = random_staff_assignment.send(role_name)
          check_access rand_user, @kase, false, false
        }
      end

      it 'who has a task for the case' do
        if @klass == Crm::Case
          # get a user
          random_staff_assignment = FactoryGirl.create :usage_staff_assignment_w_assoc, agent:@random
          role_fields = [:administrative_assistant, :case_manager, :sales_assistant, :sales_coordinator, :sales_support]
          chosen_role = role_fields.sample
          role_fields.delete chosen_role
          chosen_user = random_staff_assignment.send chosen_role
          # add a task for user to @kase
          status = Crm::Status.create
          task = Crm::SystemTask.create assigned_to_id:chosen_user.id
          status.system_tasks << task
          @kase.statuses << status
          # verify
          role_fields.each{|field|
            user = random_staff_assignment.send(field)
            check_access user, @kase, false, false
          }
          check_access chosen_user, @kase, true, true
        end
      end
    end

    describe 'super user' do
      it 'can access any kase' do
        role_id = (Usage::Role::SYSTEM_ID..Usage::Role::ADMIN_ID).to_a.sample
        super_user = FactoryGirl.create :usage_user, role_id:role_id
        [@parent_resource, @agent_resource, @child_resource, @grandchild_resource, @sibling_resource, @nephew_resource, @random_resource].each{|kase|
          check_access super_user, kase, true, true
        }
      end
    end

    describe 'manager' do
      it 'can access siblings\' cases' do
        manager = FactoryGirl.create :usage_user, role_id:Usage::Role::MANAGER_ID, parent:@parent
        [@agent_resource, @sibling_resource].each{|kase|
          check_access manager, kase, true, true
        }
        [@parent_resource, @child_resource, @grandchild_resource, @nephew_resource, @random_resource].each{|kase|
          check_access manager, kase, false, false
        }
      end
    end

    def check_access user, kase, editable, viewable
      kase.editable?(user).should eq editable
      kase.viewable?(user).should eq viewable
    end
  end

  describe '::editables? and ::viewables? for' do
    describe 'agent' do
      it 'should scope/omit siblings\' resources, according to permissions' do
        access_permutations.each do |settings|
          @agent.can_edit_siblings_resources = settings[0]
          @agent.can_view_siblings_resources = settings[1]
          check_inclusion
        end
      end

      it 'should scope/omit descendents\' resources, according to permissions' do
        access_permutations.each do |settings|
          @agent.can_edit_descendents_resources = settings[0]
          @agent.can_view_descendents_resources = settings[1]
          check_inclusion
        end
      end

      it 'should scope/omit nephews\' resources, according to permissions' do
        access_permutations.each do |settings|
          @agent.can_edit_nephews_resources = settings[0]
          @agent.can_view_nephews_resources = settings[1]
          check_inclusion
        end
      end
    end

    def check_inclusion
      # get editables and viewables
      editables = @klass.editables(@agent).all
      editables.should_not be_empty          
      viewables = @klass.viewables(@agent).all
      viewables.should_not be_empty
      # verify
      _check_inclusion editables, @agent.can_edit_siblings_resources, @sibling_resource, "edit siblings"
      _check_inclusion viewables, @agent.can_view_siblings_resources, @sibling_resource, "view siblings"
      _check_inclusion editables, @agent.can_edit_descendents_resources || @agent.can_edit_nephews_resources, @child_resource, "edit descendents child"
      _check_inclusion viewables, @agent.can_view_descendents_resources || @agent.can_view_nephews_resources, @child_resource, "view descendents child"
      _check_inclusion editables, @agent.can_edit_descendents_resources || @agent.can_edit_nephews_resources, @grandchild_resource, "edit descendents grandchild"
      _check_inclusion viewables, @agent.can_view_descendents_resources || @agent.can_view_nephews_resources, @grandchild_resource, "view descendents grandchild"
      _check_inclusion editables, @agent.can_edit_nephews_resources, @nephew_resource, "edit nephews"
      _check_inclusion viewables, @agent.can_view_nephews_resources, @nephew_resource, "view nephews"
      _check_inclusion editables, false, @random_resource, "edit random"
      _check_inclusion viewables, false, @random_resource, "view random"
      _check_inclusion editables, false, @parent_resource, "edit parent"
      _check_inclusion viewables, false, @parent_resource, "view parent"
      _check_inclusion editables, true, @agent_resource, "edit own"
      _check_inclusion viewables, true, @agent_resource, "view own"
    end

    # convenience method
    def _check_inclusion collection, access, kase, msg
      if access
        collection.compact.map(&:id).should include(kase.id), "#{access} #{msg}"
      else
        collection.compact.map(&:id).should_not include(kase.id), "#{access} #{msg}"
      end
    end
  end
end
