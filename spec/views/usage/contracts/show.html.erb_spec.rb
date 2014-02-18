require 'spec_helper'

describe "usage/contracts/show" do
  before(:each) do
    @usage_contract = assign(:usage_contract, stub_model(Usage::Contract))
  end

  it "renders attributes in <p>" do
    pending "Broken"
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
