require 'spec_helper'

describe Usage::LeadDistributionWeight do
  PARENT_ID_RANGE = (1..2)
  USERS_PER_PARENT = 4
  LEAD_TYPE_ID_RANGE = (1..3)

  before :all do
    # add an attr accessor for remembering the previous countdown
    class ::Usage::LeadDistributionWeight
      attr_accessor :prev_countdown
    end
    # build parent Users
    PARENT_ID_RANGE.each{ |i|
      unless Usage::User.where(id:i).first.present?
        u = FactoryGirl.create :usage_user, id:i
      end
    }
    # build child Users
    PARENT_ID_RANGE.each{ |i|
      FactoryGirl.create_list :usage_user, USERS_PER_PARENT, parent_id:i
    }
    # set var @users
    @users = Usage::User.where(parent_id:PARENT_ID_RANGE.to_a).all
    # build weights for each user for each lead type
    LEAD_TYPE_ID_RANGE.each{ |i|
      @users.each{ |user|
        FactoryGirl.create :usage_lead_distribution_weight, tag_value_id:i, agent_id:user.id
      }
    }
  end

  it "should respond for all attributes" do
    weight = Usage::LeadDistributionWeight.new
    %w[ agent premium_limit tag_value weight countdown lock_version
      ].each do |attr|
      weight.should respond_to(attr)
    end
  end

  describe "#decrement_countdown!" do
    it "should decrement countdown by 1" do
      weight = random_weight
      expectation = weight.countdown - 1
      weight.decrement_countdown!
      weight.countdown.should eq expectation
    end

    describe "when countdown reaches 0" do
      it "should increment countdown for all LDWs for given lead type and parentage but no others" do
        # prepare weight, store current countdowns, and call method
        chosen_weight = random_weight
        chosen_weight.update_attributes(countdown:1).should eq true
        store_current_countdowns @users
        @users.each{|u|
          u.lead_distribution_weights.each{|w|
            db_weight = Usage::LeadDistributionWeight.find(w.id)
            w.prev_countdown.should eq(w.countdown)
            w.countdown.should eq(db_weight.countdown)
            w.prev_countdown.should eq(db_weight.countdown)
          }
        }
        chosen_weight.decrement_countdown!
        # verify results
        @users.each{ |u|
          u.lead_distribution_weights.each{ |w|
            current_countdown = Usage::LeadDistributionWeight.find(w.id).countdown
            if w.tag_value_id == chosen_weight.tag_value_id and u.parent_id == chosen_weight.agent.parent_id
              if w.id == chosen_weight.id
                current_countdown.should eq(w.prev_countdown + w.weight - 1), "id: #{w.id}. Expected #{w.prev_countdown + w.weight - 1}. Got #{current_countdown}. Weight: #{w.weight}."
              else
                current_countdown.should eq(w.prev_countdown + w.weight), "id: #{w.id}. Expected #{w.prev_countdown + w.weight}. Got #{current_countdown}. Weight: #{w.weight}."
              end
            else
              current_countdown.should eq w.prev_countdown
            end
          }
        }
      end
    end
  end

  describe "#increment_countdown!" do
    it "should increment countdown by weight" do
      weight = random_weight
      expectation = weight.countdown + weight.weight
      weight.increment_countdown!
      weight.countdown.should eq expectation
    end
  end

  describe "::increment_countdowns" do
    it 'should increment countdowns by weight for all children of given user for lead type id' do
      store_current_countdowns @users
      @users.each{|u|
        u.lead_distribution_weights.each{|w|
          db_weight = Usage::LeadDistributionWeight.find(w.id)
          w.prev_countdown.should eq(w.countdown)
          w.countdown.should eq(db_weight.countdown)
          w.prev_countdown.should eq(db_weight.countdown)
        }
      }
      # choose vars
      lead_type_id = LEAD_TYPE_ID_RANGE.to_a.sample
      parent_id = PARENT_ID_RANGE.to_a.sample
      # run method
      Usage::LeadDistributionWeight.increment_countdowns parent_id, lead_type_id
      # verify results
      @users.each{|u|
        u.lead_distribution_weights.each{|w|
          db_weight = Usage::LeadDistributionWeight.find(w.id)
          if u.parent_id == parent_id and w.tag_value_id == lead_type_id
            db_weight.countdown.should eq(w.prev_countdown + w.weight), "#{w.prev_countdown} != #{db_weight.countdown} - #{w.weight}"
          else
            db_weight.countdown.should eq(w.prev_countdown), "#{w.prev_countdown} != #{db_weight.countdown} - #{w.weight}"
          end
        }
      }
    end
  end

  # Return a random LeadDistributionWeight from among those created for this spec
  def random_weight
    Usage::User.find(PARENT_ID_RANGE.to_a.sample).children.sample.lead_distribution_weights.sample
  end

  # Store current countdowns on each weight object
  def store_current_countdowns users
    users.each{|u|
      u.lead_distribution_weights.reload
      u.lead_distribution_weights.each{|w|
        w.prev_countdown = w.countdown
      }
    }
  end
end
