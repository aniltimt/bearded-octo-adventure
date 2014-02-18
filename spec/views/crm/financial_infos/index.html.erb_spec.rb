require 'spec_helper'

describe "crm/financial_infos/index" do
  before(:each) do
    assign(:crm_financial_infos, [
      stub_model(Crm::FinancialInfo,
        :asset_401k => 1,
        :asset_home_equity => 2,
        :asset_investments => 3,
        :asset_pension => 4,
        :asset_real_estate => 5,
        :asset_savings => 6,
        :liability_auto => 7,
        :liability_credit => 8,
        :liability_education => 9,
        :liability_estate_settlement => 10,
        :liability_mortgage => 11,
        :liability_other => 12
      ),
      stub_model(Crm::FinancialInfo,
        :asset_401k => 1,
        :asset_home_equity => 2,
        :asset_investments => 3,
        :asset_pension => 4,
        :asset_real_estate => 5,
        :asset_savings => 6,
        :liability_auto => 7,
        :liability_credit => 8,
        :liability_education => 9,
        :liability_estate_settlement => 10,
        :liability_mortgage => 11,
        :liability_other => 12
      )
    ])
  end

  it "renders a list of crm/financial_infos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
  end
end
