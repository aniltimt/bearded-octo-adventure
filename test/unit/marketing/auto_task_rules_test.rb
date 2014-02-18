require 'test_helper'

class AutoTaskRulesTest < ActiveSupport::TestCase
	#unit test is a test for the model.

	test "should save when valid" do#currently passes
		@atr=FactoryGirl.build(:atr)
		assert @atr.save, "Failed to save a valid AutoTaskRule."
	end

	test "should not save without a campaign" do#currently fails
		@atr=FactoryGirl.build(:atr, campaign_id: nil)
		assert !@atr.save, "Saved without a Campaign."
	end
	test "should not save without an auto system task rule" do#currently fails
		@atr=FactoryGirl.build(:atr, auto_system_task_rule_id: nil)
		assert !@atr.save, "Saved without an AutoSystemTaskRule."
	end

	#might want to test for validity of campaign and auto_system_task_rule?
end