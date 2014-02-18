class Usage::StaffAssignment < ActiveRecord::Base
  attr_accessible :administrative_assistant_id, :case_manager_id, :manager_id,
                  :policy_specialist_id, :sales_assistant_id, :sales_coordinator_id,
                  :sales_support_id, :administrative_assistant_name, :case_manager_name, :manager_name,
                  :policy_specialist_name, :sales_assistant_name, :sales_coordinator_name,
                  :sales_support_name
                  
  attr_accessor :administrative_assistant_name, :case_manager_name, :manager_name,
                :policy_specialist_name, :sales_assistant_name, :sales_coordinator_name,
                :sales_support_name

  has_one :case, class_name: "Crm::Case"
  has_one :crm_connection, class_name: "Crm::Connection"
  has_one :agent, class_name: "Usage::User"
  belongs_to :administrative_assistant, class_name: "Usage::User"
  belongs_to :case_manager, class_name: "Usage::User"
  belongs_to :manager, class_name: "Usage::User"
  belongs_to :policy_specialist, class_name: "Usage::User"
  belongs_to :sales_assistant, class_name: "Usage::User"
  belongs_to :sales_coordinator, class_name: "Usage::User"
  belongs_to :sales_support, class_name: "Usage::User"


  # Scope Users which are viewable for a given User
  scope :viewables, lambda { |user|
    if not (user.can_view_siblings? or user.can_view_descendents? or user.can_view_nephews?)
      return where(:id => user.id)
    end
    rel = joins('INNER JOIN `usage_ascendents_descendents` ON `usage_ascendents_descendents`.`descendent_id` = `usage_users`.`id`')
    if user.can_view_siblings? and user.can_view_descendents? and user.can_view_nephews?
      rel = rel.where('usage_ascendents_descendents.ascendent_id' => user.parent_id)
    else
      statement_string = []
      statement_params = []
      if user.can_view_descendents?
        statement_string << 'ascendent_id = ?'
        statement_params << user.id
      end
      if user.can_view_siblings?
        statement_string << 'parent_id = ?'
        statement_params << user.parent_id
      end
      if user.can_view_nephews?
        statement_string << 'ascendent_id in (?)'
        statement_params << siblings(user).select(:id).map(&:id)
      end
      rel = rel.where(statement_string.join(' OR '), *statement_params)
    end
    rel
  }

  def can_edit_user?(arg)
    arg_user = arg.kind_of?(Usage::User) ? arg : Usage::User.find_by_id(arg)

    return true if self.role.super?
    if self.can_edit_self === true && self.id === arg_user.id
      return true
    end
    if self.can_edit_siblings === true && self.parent_id === arg_user.parent_id
      return true
    end
    return true if arg_user.ascendent_ids.include?(self.id)
    false
  end

  # Returns true, false, or nil
  def include? user_or_id
    user = user_or_id.is_a?(Fixnum) ? Usage::User.find(user_or_id) : user_or_id
    user_id = user_id_for_role_id(user.role_id)
    user_id.nil? ? nil : user.id == user_id
  end

  # Returns the field on this model that matches the role_id supplied
  def user_id_for_role_id role_id
    case role_id
    when Usage::Role::SALES_COORDINATOR_ID
      self.sales_coordinator_id
    when Usage::Role::SALES_ASSISTANT_ID
      self.sales_assistant_id
    when Usage::Role::SALES_SUPPORT_ID
      self.sales_support_id
    when Usage::Role::ADMINISTRATIVE_ASSISTANT_ID
      self.administrative_assistant_id
    when Usage::Role::CASE_MANAGER
      self.case_manager_id
    when Usage::Role::MANAGER_ID
      self.manager_id
    end
  end
end
