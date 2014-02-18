class Crm::EzlJoin < ActiveRecord::Base
  include Crm::BelongsToConnectionStereotype
  attr_accessible :ezl_id, :connection_id
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
end
