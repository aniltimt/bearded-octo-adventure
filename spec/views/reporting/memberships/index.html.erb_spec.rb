require 'spec_helper'

describe "reporting/memberships/index" do
  before(:each) do
    assign(:reporting_memberships, [
      stub_model(Reporting::Membership),
      stub_model(Reporting::Membership)
    ])
  end

  it "renders a list of reporting/memberships" do
    pending "Broken"
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
