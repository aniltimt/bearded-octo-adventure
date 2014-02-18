module Crm::BelongsToCaseStereotype
  extend ActiveSupport::Concern
  include Crm::Accessible

  def editable? user_or_id
    self.case.editable?(user_or_id) if self.case.present?
  end

  def viewable? user_or_id
    self.case.viewable?(user_or_id) if self.case.present?
  end

  included do
    scope :editables, lambda{|arg_user|
      case_join.where(
        Crm::Case::editables(arg_user).where_values.reduce(:and)
        )
    }

    scope :viewables, lambda{|arg_user|
      case_join.where(
        Crm::Case::viewables(arg_user).where_values.reduce(:and)
        )
    }

    scope :case_join, lambda{
      joins(:case)
      .joins('INNER JOIN usage_users ON
        usage_users.id = crm_cases.agent_id')
      .joins('INNER JOIN usage_ascendents_descendents ON
        usage_ascendents_descendents.descendent_id = usage_users.id')
    }
  end
end
