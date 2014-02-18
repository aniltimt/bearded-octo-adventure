require 'test_helper'

class AutoSystemTaskRulesTest < ActiveSupport::TestCase
	#unit test is a test for the model.

	#not sure which (if not all) attributes are required, and what constrainst should be put on those?
	
	test "should save when valid" do#currently passes
		#incomplete, since i don't know which attributes are required to be present and not null
		#db schema only shows timestamps as required
		#so only currently testing for presence of associations
		@astr=FactoryGirl.build(:astr)
		assert @astr.save, "Failed to save a valid AutoTaskRule."
	end

	test "should not save without a role" do#currently fails
		@astr=FactoryGirl.build(:astr, role_id: nil)
		assert !@astr.save, "Saved without a Role."
	end
	test "should not save without a task type" do#currently fails
		@astr=FactoryGirl.build(:astr, task_type_id: nil)
		assert !@astr.save, "Saved without a SystemTaskType."
	end
	test "should not save without a status type" do#currently fails
		@astr=FactoryGirl.build(:astr, status_type_id: nil)
		assert !@astr.save, "Saved without a StatusType."
	end
end