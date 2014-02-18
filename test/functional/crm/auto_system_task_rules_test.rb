require 'test_helper'

class AutoSystemTaskRulesTest < ActiveSupport::TestCase
	#functional test is a test for the controller.

	test "create increments count of auto system task rules" do#currently passes
		@all_astrs_before=Crm::AutoSystemTaskRule.all.count
		@all_astrs_before_plus_one=@all_astrs_before+1
		FactoryGirl.create(:astr)
		@all_astrs_after=Crm::AutoSystemTaskRule.all.count
		assert_equal @all_astrs_before_plus_one, @all_astrs_after,""
	end

	test "destroy decrements count of auto system task rules" do
		#
	end

end