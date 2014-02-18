# These methods are shared between Connection and Case because
# each of these models has an :agent and a :staff_assignment.
module Crm::Accessible
  extend ActiveSupport::Concern

  def editable? user_or_id
    _accessible? user_or_id, :edit
  end
  
  def viewable? user_or_id
    _accessible? user_or_id, :view
  end

  included do
    scope :editables, lambda{|user_or_id|
      _editables_or_viewables(user_or_id, :edit)
    }

    scope :viewables, lambda{|user_or_id|
      _editables_or_viewables(user_or_id, :view)
    }

    scope :_editables_or_viewables, lambda{|user_or_id, access_mode|
      # ensure a Usage::User object for argument
      arg_user = user_or_id.is_a?(Usage::User) ? user_or_id : Usage::User.find(user_or_id)
      # use user role to determine logic
      if arg_user.agent? or arg_user.manager?
        _accessibles_through_family(arg_user, access_mode)
      else
        relation.where(agent_id:arg_user.id)
      end
    }

    scope :_accessibles_through_family, lambda{|arg_user, access_mode|
      # determine can_<view/edit>_<descendents/siblings/nephews>_resources
      descendent_access, sibling_access, nephew_access =
      if access_mode == :view
        [arg_user.can_view_descendents_resources, arg_user.can_view_siblings_resources || arg_user.manager?, arg_user.can_view_nephews_resources]
      else
        [arg_user.can_edit_descendents_resources, arg_user.can_edit_siblings_resources || arg_user.manager?, arg_user.can_edit_nephews_resources]
      end
      # choose scope
      if nephew_access # and descendent_access (inferred)
        if sibling_access
          return family_joins.where(
            parent_downstream(arg_user)
            )
        else
          kases = Arel::Table.new(self.table_name)
          return family_joins.where(
            kases[:agent_id].eq(arg_user.id).or team_downstream(arg_user)
            )
        end
      elsif sibling_access and descendent_access
        return family_joins.where(
          siblings_resources(arg_user).or descendents_resources(arg_user)
          )
      elsif sibling_access
        return joins(:agent).where(
          siblings_resources(arg_user)
          )
      elsif descendent_access
        kases = Arel::Table.new(self.table_name)
        return family_joins.where(
          kases[:agent_id].eq(arg_user.id).or descendents_resources(arg_user)
          )
      end
      # default return: access granted only to resources owned by arg_user
      return where(agent_id:arg_user.id)
    }

    scope :family_joins, lambda {
      relation
      .joins(:agent)
      .joins('INNER JOIN usage_ascendents_descendents ON
         usage_ascendents_descendents.descendent_id = usage_users.id')
    }

    # Returns Arel expression
    # Must be scoped with family_joins.
    def self.descendents_resources user
      Arel::Table.new('usage_ascendents_descendents')[:ascendent_id].eq(user.id)
    end

    # Returns Arel expression
    # Must be scoped with join(:agent).
    def self.siblings_resources user
      Arel::Table.new(Usage::User.table_name)[:parent_id].eq(user.parent_id)
    end

    # Returns Arel expression
    # Scope nephews', descendents', siblings', and self's resources
    # Must be scoped with family_joins.
    def self.parent_downstream user
      Arel::Table.new('usage_ascendents_descendents')[:ascendent_id].eq(user.parent_id)
    end

    # Returns Arel expression
    # Scope nephews' and descendents' resources but not siblings' or self's
    # Must be scoped with family_joins.
    def self.team_downstream user
      users = Arel::Table.new(Usage::User.table_name)
      ascendents = Arel::Table.new('usage_ascendents_descendents')
      users[:parent_id].not_eq(user.parent_id).and(ascendents[:ascendent_id].eq(user.parent_id))
    end
  end

  private

  # Access is determined in part by the role of the User.
  #
  # A super user can access anything.
  #
  # An agent can access a case/connection he owns or which is owned by 
  # a family member, if the agent has permission to access that family
  # member's resources.
  #
  # A sales support user can access a case/connection whose agent's 
  # support staff includes the user or a case/connection which has a
  # status which has a task which is assigned to the user.
  #
  # A manager can access a case/connection whose agent is a sibling.
  def _accessible? user_or_id, edit_or_view
    # get user id
    user_id = user_or_id.to_i
    # quick response if user is self.agent
    return true if self.agent_id == user_id
    # get user object
    user = user_or_id.is_a?(Fixnum) ? Usage::User.find(user_or_id) : user_or_id
    if user.super?
      return true
    elsif user.agent? or user.manager?
      return true if _accessible_through_family?(user, edit_or_view)
    elsif user.sales_support?
      return true if _accessible_for_sales_support?(user)
    end
    false
  end

  def _accessible_for_sales_support? user
    # succeeds if agent has user in staff assignment
    return true if self.agent.staff_assignment.include? user
    # succeeds if this obj has a status which has a task which is assigned to user
    if self.is_a? Crm::Case
      tasks_table = Crm::SystemTask.table_name
      task = self.statuses.joins(:system_tasks)
      .where("#{tasks_table}.assigned_to_id = ?", user.id)
      .limit(1).select("#{tasks_table}.id")
      return task.present?
    end
    # default return
    false
  end

  # Returns true if the user may access the resource through a sibling, nephew, or descendent
  def _accessible_through_family? user, edit_or_view
    descendent_access, sibling_access, nephew_access =
    if edit_or_view == :edit
      [user.can_edit_descendents_resources, user.can_edit_siblings_resources || user.manager?, user.can_edit_nephews_resources]
    else
      [user.can_view_descendents_resources, user.can_view_siblings_resources || user.manager?, user.can_view_nephews_resources]
    end
    # check permission to access siblings' stuff
    return true if sibling_access and self.agent.parent_id == user.parent_id
    # check permission to access descendents' stuff
    return true if descendent_access and self.agent.descendent?(user)
    # check permission to access nephews' stuff
    return true if nephew_access and self.agent.parent_id != user.parent_id and self.agent.descendent?(user.parent)
    # default return
    false
  end
end
