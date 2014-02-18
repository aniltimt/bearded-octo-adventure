require 'spec_helper'

describe "reporting/memberships/show" do
  before(:each) do
    @reporting_membership = assign(:reporting_membership, stub_model(Reporting::Membership))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
