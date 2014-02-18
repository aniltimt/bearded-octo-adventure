require 'spec_helper'

describe "crm/financial_infos/new" do
  before(:each) do
    assign(:crm_financial_info, stub_model(Crm::FinancialInfo,
      :asset_401k => 1,
      :asset_home_equity => 1,
      :asset_investments => 1,
      :asset_pension => 1,
      :asset_real_estate => 1,
      :asset_savings => 1,
      :liability_auto => 1,
      :liability_credit => 1,
      :liability_education => 1,
      :liability_estate_settlement => 1,
      :liability_mortgage => 1,
      :liability_other => 1
    ).as_new_record)
  end

  it "renders new crm_financial_info form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => crm_financial_infos_path, :method => "post" do
      assert_select "input#crm_financial_info_asset_401k", :name => "crm_financial_info[asset_401k]"
      assert_select "input#crm_financial_info_asset_home_equity", :name => "crm_financial_info[asset_home_equity]"
      assert_select "input#crm_financial_info_asset_investments", :name => "crm_financial_info[asset_investments]"
      assert_select "input#crm_financial_info_asset_pension", :name => "crm_financial_info[asset_pension]"
      assert_select "input#crm_financial_info_asset_real_estate", :name => "crm_financial_info[asset_real_estate]"
      assert_select "input#crm_financial_info_asset_savings", :name => "crm_financial_info[asset_savings]"
      assert_select "input#crm_financial_info_liability_auto", :name => "crm_financial_info[liability_auto]"
      assert_select "input#crm_financial_info_liability_credit", :name => "crm_financial_info[liability_credit]"
      assert_select "input#crm_financial_info_liability_education", :name => "crm_financial_info[liability_education]"
      assert_select "input#crm_financial_info_liability_estate_settlement", :name => "crm_financial_info[liability_estate_settlement]"
      assert_select "input#crm_financial_info_liability_mortgage", :name => "crm_financial_info[liability_mortgage]"
      assert_select "input#crm_financial_info_liability_other", :name => "crm_financial_info[liability_other]"
    end
  end
end
