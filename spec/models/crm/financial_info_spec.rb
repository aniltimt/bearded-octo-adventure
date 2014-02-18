require 'spec_helper'

describe Crm::FinancialInfo do
  it "should respond to accessors for fields" do
    fi = Crm::FinancialInfo.new
    %w(asset_401k asset_home_equity asset_investments asset_pension asset_real_estate asset_savings income liability_auto liability_credit liability_education liability_estate_settlement liability_mortgage liability_other net_worth).each do |field|
      fi.should respond_to field
    end
  end
end
