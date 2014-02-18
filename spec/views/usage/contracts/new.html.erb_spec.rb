require 'spec_helper'

describe "usage/contracts/new" do
  before(:each) do
    assign(:usage_contract, stub_model(Usage::Contract).as_new_record)
  end

  it "renders new usage_contract form" do
    pending "Broken"
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", usage_contracts_path, "post" do
    end
  end
end
