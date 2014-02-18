require 'spec_helper'
require 'support/feature_helpers.rb'
require 'support/lead_form_helpers.rb'
require 'rspec/mocks'
RSpec.configure do |config|
  config.include FeatureHelpers
  config.include LeadFormHelpers
end

describe 'Lead form' do

  DATE_PROC = lambda{|v| v.strftime(APP_CONFIG['date_format'])}

  before :each do
    FactoryGirl.create :usage_user_w_assoc, role_id:role_id
    ApplicationController.any_instance.stub(:current_user).and_return(current_user)
    current_user.should be_present
    @connection = FactoryGirl.create :crm_connection_w_assoc, agent_id:current_user.id
    @case = FactoryGirl.build :crm_case_w_assoc, agent_id:current_user.id
  end

  it 'should be fillable' do
    visit new_quoting_lead_path crm_connection_id:@connection.id
    page.should have_content 'Online Application'
    fill_lead_form
  end

  it 'should update a Connection, create a Case, and lead to Cases#details view' do
    visit new_quoting_lead_path crm_connection_id:@connection.id
    @connection = FactoryGirl.build :crm_connection_w_assoc
    page.should have_content 'Online Application'
    fill_lead_form
  end

end
