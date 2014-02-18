module Crm::BelongsToConnectionStereotype
  extend ActiveSupport::Concern
  include Crm::Accessible

  delegate :editable?, to: :crm_connection, allow_nil:true
  delegate :viewable?, to: :crm_connection, allow_nil:true

  included do
    scope :editables, lambda{|arg_user|
      connection_join.where(
        Crm::Connection::editables(arg_user).where_values.reduce(:and)
        )
    }

    scope :viewables, lambda{|arg_user|
      connection_join.where(
        Crm::Connection::viewables(arg_user).where_values.reduce(:and)
        )
    }

    scope :connection_join, lambda{
      joins(:crm_connection)
      .joins('INNER JOIN usage_users ON
        usage_users.id = crm_connections.agent_id')
      .joins('INNER JOIN usage_ascendents_descendents ON
        usage_ascendents_descendents.descendent_id = usage_users.id')
    }
  end
end
