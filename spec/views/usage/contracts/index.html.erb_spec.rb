require 'spec_helper'

describe "usage/contracts/index" do
  before(:each) do
    assign(:usage_contracts, [
      stub_model(Usage::Contract),
      stub_model(Usage::Contract)
    ])
  end

  it "renders a list of usage/contracts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
