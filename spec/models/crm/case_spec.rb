require 'spec_helper'
require 'support/crm/accessible_examples'
require 'support/data_helper'
RSpec.configure do |config|
  config.include DataHelper
end

describe Crm::Case do
  it_should_behave_like "Crm::Accessible", Crm::Case, :crm_case

  it "should call the callback to change" do
    crm_connection = FactoryGirl.create(:crm_connection, :connection_type_id=>nil)
    crm_case = FactoryGirl.build(:crm_case, :connection_id => crm_connection.id)
    crm_case.crm_connection.connection_type.try(:name).should==nil
    crm_case.save
    crm_case.crm_connection.connection_type.try(:name).should=="lead"
  end

  it "should respond to accessors for fields" do
    crm_case = Crm::Case.new
    %w[active agent_id approved_details_id approved_premium_due bind cross_sell current_insurance_amount effective_date equal_share_contingent_bens equal_share_primary_bens exam_company exam_num exam_status exam_time insurance_exists ipo owner_id policy_number policy_period_expiration quoted_details_id staff_assignment_id status_id submitted_details_id submitted_qualified termination_date underwriter_assist up_sell].each do |field|
      crm_case.should respond_to(field)
    end
  end

  describe "#wholesale_app?" do
    let(:crm_case) { Crm::Case.new(crm_connection: crm_connection) }
    let(:crm_connection) { Crm::Connection.new }

    before do
      crm_connection.profile = profile
    end

    ["ezlife", "eZlife", "Ezlife", "EZlife"].each do |name|
      context "when the profile on the connection is #{name}" do
        let(:profile) { Usage::Profile.new(name: name) }

        it "returns false" do
          crm_case.wholesale_app?.should == false
        end
      end
    end

    context "when the profile on the connection is anything else" do
      let(:profile) { Usage::Profile.new(name: "potato") }

      it "returns true" do
        crm_case.wholesale_app?.should == true
      end
    end

    context "when there is no profile on the connection" do
      let(:profile) { nil }

      it "returns true" do
        crm_case.wholesale_app?.should == true
      end
    end
  end

  describe '#valid_quoter?' do

    describe 'returns true' do

      it 'when needed fields are valid' do
        pending "Broken"
        build_valid_quoter
        Rails.logger.warn @case.errors.inspect unless @case.valid_quoter?
        @case.valid_quoter?.should be true
      end

    end

    describe 'returns false' do

      it 'when crm_connection is nil' do
        build_valid_quoter
        @case.crm_connection = nil
        @case.valid_quoter?.should be false
        @case.errors.should have_key(:crm_connection)
      end

      it 'when crm_connection lacks needed fields' do
        [:birth, :health_info, :contact_info, :gender].each do |field|
          build_valid_quoter
          @case.crm_connection.attributes = {field => nil}
          @case.valid_quoter?.should be false
          @case.crm_connection.errors.should have_key(field)
        end
      end

      it 'when health_info lacks needed fields' do
        [:feet, :inches, :weight].each do |field|
          build_valid_quoter
          @case.crm_connection.health_info.attributes = {field => nil}
          @case.valid_quoter?.should be false
          @case.crm_connection.health_info.errors.should have_key(field)
        end
      end

      it 'when contact_info lacks needed fields' do
        [:state].each do |field|
          build_valid_quoter
          @case.crm_connection.contact_info.attributes = {field => nil}
          @case.valid_quoter?.should be false
          @case.crm_connection.contact_info.errors.should have_key(field)
        end
      end

      it 'when quoted_details lacks needed fields' do
        [:face_amount, :category].each do |field|
          build_valid_quoter
          @case.quoted_details.attributes = {field => nil}
          @case.valid_quoter?.should be false
          @case.quoted_details.errors.should have_key(field)
        end
      end

    end

    def build_valid_quoter
      @case = FactoryGirl.build :crm_case_w_assoc
      @case.crm_connection = FactoryGirl.build :crm_connection_w_assoc
    end
  end

  describe '#find_agent_for_assignment' do
    PARENT_ID_RANGE = (1..2)
    STATE_ID_RANGE = (1..2)
    LEAD_TYPE_ID_RANGE = (1..2)
    ROLE_ID_RANGE = ((Usage::Role.agent_id)..(Usage::Role.agent_id + 2))
    PREMIUM_LIMIT_RANGE = (1..2)
    COUNTDOWN_RANGE = (0..2)
    
    before :all do
      # build parent Users
      PARENT_ID_RANGE.each{ |i|
        unless Usage::User.where(id:i).first.present?
          u = FactoryGirl.create :usage_user, id:i
        end
      }
      # build a user for each parent, state, role, premium limit, and countdown in the ranges given
      # in the constants above
      # ...for group
      PARENT_ID_RANGE.each{ |parent_id|
        # ...for agent role
        ROLE_ID_RANGE.each { |role_id|
          # ...available
          [20,40].each { |minutes_ago|
            # ...not suspended
            [true, false].each { |suspension|
              # ...for state (licensing)
              STATE_ID_RANGE.each { |state_id|
                # ...for premium limit
                PREMIUM_LIMIT_RANGE.each { |premium_limit|
                  # ...for countdown
                  COUNTDOWN_RANGE.each { |countdown|
                    # create user
                    user = FactoryGirl.create :usage_user,
                      parent_id:parent_id,
                      role_id:role_id
                    user.last_request_at = minutes_ago.minutes.ago
                    # create agent field set
                    user.agent_field_set = FactoryGirl.create :usage_agent_field_set,
                      temporary_suspension:suspension
                    # save agent field set and last login on user
                    user.save
                    # create license (for state)
                    FactoryGirl.create :usage_license,
                      state_id:state_id,
                      agent_field_set_id:user.agent_field_set_id
                    user.reload
                    # create lead distribution weights for each lead type
                    LEAD_TYPE_ID_RANGE.each {|lead_type_id|
                      FactoryGirl.create :usage_lead_distribution_weight,
                        agent_id:user.id,
                        tag_value_id:lead_type_id,
                        premium_limit:premium_limit,
                        countdown: countdown
                    }
                    user.reload
                    # confirm objects have been created correctly
                    user.parent_id.should eq parent_id
                    user.role_id.should eq role_id
                    user.agent_field_set.temporary_suspension.should eq suspension
                    user.agent_field_set.licenses.map(&:state_id).should include(state_id)
                    LEAD_TYPE_ID_RANGE.each{ |lead_type_id|
                      user.lead_distribution_weights.map(&:tag_value_id).should include(lead_type_id)
                    }
                  }
                }
              }
            }
          }
        }
      }
      # define @users
      @users = Usage::User.where(parent_id:PARENT_ID_RANGE.to_a).all
      # set vars for tests
      @group_id     = PARENT_ID_RANGE.to_a.sample
      @lead_type_id = LEAD_TYPE_ID_RANGE.to_a.sample
      @state_id     = STATE_ID_RANGE.to_a.sample
      @premium      = PREMIUM_LIMIT_RANGE.to_a.sample
      # build connection and case
      @connection   = FactoryGirl.create :crm_connection,
        contact_info_attributes:{
          state_id:@state_id
        }
      @connection.lead_type_id = @lead_type_id
      @connection.save
      @case = FactoryGirl.build :crm_case,
        connection_id:@connection.id,
        quoted_details_attributes:{
          annual_premium:PREMIUM_LIMIT_RANGE.max
          }
      @candidates = Usage::User.
        where(parent_id:@group_id, role_id:Usage::Role.agent_id).
        joins(:agent_field_set => :licenses).
        where('usage_licenses.state_id = ?', @state_id)
      @a0 = Usage::User.agent_for_assignment @group_id, @state_id, @lead_type_id, @premium
      pending "Usage::User::agent_for_assignment appears to need fixing" if @a0.nil?
      @assignee = @case.find_agent_for_assignment @group_id
      @assignee.should be_present
    end

    describe 'produces assignee who' do
      it 'is available' do
        proc = lambda{|user|
          user.last_request_at and user.last_request_at >= 30.minutes.ago.round(0)
        }
        verify proc, "assignee #{@assignee.id} is not available"
      end

      it 'exceeds premium limit' do
        proc = lambda{|user|
          weight = user.lead_distribution_weights.where('tag_value_id = ?', @lead_type_id).first
          return unless weight.present?
          weight.premium_limit.to_i >= @case.quoted_details.try(:computed_annual_premium)
        }
        verify proc, "case exceeds assignee #{@assignee.id}'s premium limit for lead type #{@lead_type_id}"
      end

      it 'is not suspended' do
        proc = lambda{|user|
          user.agent_field_set.temporary_suspension != true
        }
        verify proc, "assignee #{@assignee.id} is suspended"
      end

      it 'has a positive countdown' do
        proc = lambda{|user|
          weight = user.lead_distribution_weights.where('tag_value_id = ?', @lead_type_id).first
          return unless weight.present?
          weight.countdown > 0
        }
        verify proc, "assignee #{@assignee.id} hasn't a positive countdown for lead type #{@lead_type_id}"
      end

      def verify proc, message=nil
        pending "No candidates match elective scopes for #{stats}" if @candidates.none?{|c| proc.call(c)}
        assert proc.call(@assignee), message
      end
    end

    def stats
      "group #{@group.id}, state #{@state_id}, lead_type #{@lead_type.id}, premium: #{@case.computed_annual_premium}"
    end
  end
end
