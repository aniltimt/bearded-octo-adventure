class Crm::AutoSystemTaskRule < ActiveRecord::Base
  attr_accessible :role_id, :task_type_id, :template_id
  #auto task stereotype fields
  attr_accessible :status_type_id, :delay, :name, :label

  # Associations
  belongs_to :role, :foreign_key => :role_id, :class_name => "Usage::Role"
  belongs_to :task_type, :foreign_key => :task_type_id, :class_name => "Crm::SystemTaskType"
  belongs_to :status_type, class_name: "Crm::StatusType"

  def assignment(status)
    status.try(:case).try(:agent).try(:sales_support, self.role)
  end

  def user_assignment(status)
    # :policy_specialist "Need to ask regarding this."
    staff_users = {8 => :administrative_assistant, 9 => :case_manager, 10 => :manager, 7 => :sales_assistant, 6 => :sales_coordinator, 5 => :sales_support }

    if case_assignment = Usage::StaffAssignment.joins(:case).where("crm_cases.id = ?", status.try(:case).try(:id)).first.try(staff_users[self.role.try(:id)])
      return case_assignment
    end

    if agent_assignment = Usage::StaffAssignment.joins(:agent).where("usage_users.id = ?", status.try(:case).try(:agent).try(:id)).first.try(staff_users[self.role.try(:id)])
      return agent_assignment
    end

    if connection_assignment = Usage::StaffAssignment.joins(:crm_connection).where("crm_connections.id = ?", status.try(:case).try(:crm_connection).try(:id)).first.try(staff_users[self.role.try(:id)])
      return connection_assignment
    end

    if user = Usage::User.where(:role_id => self.role.try(:id)).first
      return user
    end

    return nil
  end

  def template_name
    #need to implement
  end

  def template_name=(name)
    #need to implement
  end
end
