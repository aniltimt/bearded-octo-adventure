class Marketing::Vici::ClientData < ActiveRecord::Base
  attr_accessible :client_id, :vici_id
  
  # Associations
  belongs_to :client, :class_name => "Crm::Client"
end
