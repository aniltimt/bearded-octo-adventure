require 'spec_helper'
require 'support/crm/belongs_to_accessible_stereotype_examples'

describe Crm::Physician do
  it_should_behave_like "Crm::BelongsToAccessibleStereotype", Crm::Physician, :crm_physician, Crm::Connection, :crm_connection, :crm_connection
end
