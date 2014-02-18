require 'spec_helper'

describe "reporting/memberships/edit" do
  before(:each) do
    @reporting_membership = assign(:reporting_membership, stub_model(Reporting::Membership))
  end

  it "renders the edit reporting_membership form" do
    pending "Broken"
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", reporting_membership_path(@reporting_membership), "post" do
    end
  end
end
