module Crm::HasOneConnectionStereotype
  extend ActiveSupport::Concern

  included do
    # Scope which joins connection and user
    scope :connection_join, lambda {
      joins(:crm_connection => [:agent]).
      joins('LEFT JOIN `usage_ascendents_descendents` ON
             `usage_ascendents_descendents`.`descendent_id` = `usage_users`.`id`')
      }

    # Scope editables for the models which have has_one connection
    scope :editables, lambda {|arg_user|
      rel = connection_join

      statement_string = []
      statement_params = []
      statement_string << 'crm_connections.agent_id = ?'
      statement_params << arg_user.id
      if arg_user.can_edit_descendents_resources?
        statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
          AND usage_ascendents_descendents.ascendent_id = ?)'
        statement_params << arg_user.id
      end
      if arg_user.can_edit_siblings_resources?
        statement_string << '(crm_connections.agent_id = usage_users.id
          AND usage_users.parent_id = ? )'
        statement_params << arg_user.parent_id
      end
      if arg_user.can_edit_nephews_resources?
        if arg_user.can_edit_siblings_resources?
          statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
            AND usage_ascendents_descendents.ascendent_id = ?)'
          statement_params << arg_user.parent_id
        else
          statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
            AND usage_ascendents_descendents.ascendent_id = ? AND crm_connections.agent_id <> ?)'
          statement_params << arg_user.parent_id
          statement_params << arg_user.parent_id
        end
      end

      rel = rel.where(statement_string.join(' OR '), *statement_params)
      rel
    }

    # Scope viewables for the models which have has_one connection
    scope :viewables, lambda {|arg_user|
      rel = connection_join

      statement_string = []
      statement_params = []
      statement_string << 'crm_connections.agent_id = ?'
      statement_params << arg_user.id
      if arg_user.can_view_descendents_resources?
        statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
          AND usage_ascendents_descendents.ascendent_id = ?)'
        statement_params << arg_user.id
      end
      if arg_user.can_view_siblings_resources?
        statement_string << '(crm_connections.agent_id = usage_users.id
          AND usage_users.parent_id = ? )'
        statement_params << arg_user.parent_id
      end
      if arg_user.can_view_nephews_resources?
        if arg_user.can_view_siblings_resources?
          statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
            AND usage_ascendents_descendents.ascendent_id = ?)'
          statement_params << arg_user.parent_id
        else
          statement_string << '(crm_connections.agent_id = usage_ascendents_descendents.descendent_id
            AND usage_ascendents_descendents.ascendent_id = ? AND crm_connections.agent_id <> ?)'
          statement_params << arg_user.parent_id
          statement_params << arg_user.parent_id
        end
      end

      rel = rel.where(statement_string.join(' OR '), *statement_params)
      rel
    }
  end

  def editable?(user)
    self.class.editables(user).include?(self)
  end

  def viewable?(user)
    self.class.viewables(user).include?(self)
  end

end
