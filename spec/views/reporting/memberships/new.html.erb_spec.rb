require 'spec_helper'

describe "reporting/memberships/new" do
  before(:each) do
    assign(:reporting_membership, stub_model(Reporting::Membership).as_new_record)
  end

  it "renders new reporting_membership form" do
    pending "Broken"
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", reporting_memberships_path, "post" do
    end
  end
end
