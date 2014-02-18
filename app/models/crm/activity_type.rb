class Crm::ActivityType < CluEnum
  self.table_name = 'crm_activity_types'
  self.primary_key = :id
  # attr_accessible :title, :body

  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
  belongs_to :user, class_name: 'Usage::User'

  def self.find_type_by_task_type_name(task_name)
    if ["email", "email agent"].include?(task_name)
      Crm::ActivityType.find_by_name("email")
    elsif ["letter"].include?(task_name)
      Crm::ActivityType.find_by_name("letter")
    elsif ["phone dial", "phone broadcast"].include?(task_name)
      Crm::ActivityType.find_by_name("phone")
    elsif ["sms", "sms agent"].include?(task_name)
      Crm::ActivityType.find_by_name("sms")
    end
  end
end
