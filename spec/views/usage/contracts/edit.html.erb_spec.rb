require 'spec_helper'

describe "usage/contracts/edit" do
  before(:each) do
    @usage_contract = assign(:usage_contract, stub_model(Usage::Contract))
  end

  it "renders the edit usage_contract form" do
    pending "Broken"
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", usage_contract_path(@usage_contract), "post" do
    end
  end
end
