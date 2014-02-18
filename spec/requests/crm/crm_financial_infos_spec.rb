require 'spec_helper'

describe "Crm::FinancialInfos" do
  describe "GET /crm_financial_infos" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get crm_financial_infos_path
      response.status.should be(200)
    end
  end
end
