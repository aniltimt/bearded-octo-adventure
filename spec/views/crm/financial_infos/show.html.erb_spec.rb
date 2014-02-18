require 'spec_helper'

describe "crm/financial_infos/show" do
  before(:each) do
    @crm_financial_info = assign(:crm_financial_info, stub_model(Crm::FinancialInfo,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/10/)
    rendered.should match(/11/)
    rendered.should match(/12/)
  end
end
