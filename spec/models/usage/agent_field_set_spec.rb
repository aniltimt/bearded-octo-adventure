require 'spec_helper'

describe Usage::AgentFieldSet do

  pending { should have_many(:users) }

  it "should respond for all attributes" do
    agent_field_set = Usage::AgentFieldSet.new
    [ "temporary_suspension", "premium_limit", "tz_max",
      "tz_min"
    ].each do |attr|
      agent_field_set.should respond_to(attr)
    end
  end
end
