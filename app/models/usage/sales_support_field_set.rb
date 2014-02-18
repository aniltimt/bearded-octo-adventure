class Usage::SalesSupportFieldSet < ActiveRecord::Base
  
  attr_accessible :docusign_account_id, :docusign_email, :docusign_password, :metlife_agent_id
  
  # Associations
  has_many :users
  
end
