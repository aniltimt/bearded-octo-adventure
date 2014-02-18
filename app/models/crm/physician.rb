class Crm::Physician < ActiveRecord::Base
  include Crm::BelongsToConnectionStereotype
  attr_accessible :address, :findings, :last_seen, :name, :phone, :reason,
                  :physician_type_id, :year_of_service, :connection_id
  belongs_to :physician_type, :class_name => "Crm::PhysicianType"
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
end
