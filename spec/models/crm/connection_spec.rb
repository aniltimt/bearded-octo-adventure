require 'spec_helper'
require 'support/crm/accessible_examples'

describe Crm::Connection do
  it_should_behave_like "Crm::Accessible", Crm::Connection, :crm_connection
end
