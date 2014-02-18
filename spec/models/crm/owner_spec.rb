require 'spec_helper'

describe Crm::Owner do
  it_should_behave_like "Crm::BelongsToAccessibleStereotype", Crm::Owner, :crm_owner, Crm::Case, :crm_case, :case
end
