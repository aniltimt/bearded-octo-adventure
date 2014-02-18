require 'spec_helper'

shared_examples_for "Crm::BelongsToAccessibleStereotype" do |klass, faktory, accessible_class, accessible_factory, association_name|
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
    # create connections
    @parent_accessible = FactoryGirl.create accessible_factory, agent:@parent
    @agent_accessible = FactoryGirl.create accessible_factory, agent:@agent
    @child_accessible = FactoryGirl.create accessible_factory, agent:@child
    @grandchild_accessible = FactoryGirl.create accessible_factory, agent:@grandchild
    @sibling_accessible = FactoryGirl.create accessible_factory, agent:@sibling
    @nephew_accessible = FactoryGirl.create accessible_factory, agent:@nephew
    @random_accessible = FactoryGirl.create accessible_factory, agent:@random
    # create resources
    @parent_resource = FactoryGirl.create faktory, association_name => @parent_accessible
    @agent_resource = FactoryGirl.create faktory, association_name => @agent_accessible
    @child_resource = FactoryGirl.create faktory, association_name => @child_accessible
    @grandchild_resource = FactoryGirl.create faktory, association_name => @grandchild_accessible
    @sibling_resource = FactoryGirl.create faktory, association_name => @sibling_accessible
    @nephew_resource = FactoryGirl.create faktory, association_name => @nephew_accessible
    @random_resource = FactoryGirl.create faktory, association_name => @random_accessible
  end

  describe "::editables and ::viewables" do
    context 'agent' do
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
      editables.each{|obj| obj.should be_a(@klass)}
      viewables = @klass.viewables(@agent).all
      viewables.should_not be_empty
      viewables.each{|obj| obj.should be_a(@klass)}
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
        collection.should include(kase), "#{access} #{msg}"
      else
        collection.should_not include(kase), "#{access} #{msg}"
      end
    end
  end
end