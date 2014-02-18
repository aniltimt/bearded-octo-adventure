class Crm::SystemTask < ActiveRecord::Base

  attr_accessor :due_at_date
  attr_writer :curr_user

  attr_accessible :assigned_to, :created_by, :recipient, :task_type_id, :template_id,
    :connection_id, :due_at, :label, :status_id, :owner_id, :ownership_id, :completed_at,
    :due_at_date, :assigned_to_id

  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
  belongs_to :status, class_name: "Crm::Status", :foreign_key => :status_id
  belongs_to :assigned_to, class_name: "Usage::User", :foreign_key => :assigned_to_id
  belongs_to :created, class_name: "Usage::User", :foreign_key => :created_by
  belongs_to :task_type, class_name: "Crm::SystemTaskType"
  belongs_to :owner, class_name: "Usage::User"
  belongs_to :ownership, class_name: "Ownership"
  belongs_to :marketing_email_template, class_name: "Marketing::Email::Template", :foreign_key => :template_id

  scope :get_earliest_task, lambda { |crm_case|
    where("completed_at is NULL AND status_id = ?", crm_case.status_id)
    .order("due_at ASC")
  }

  scope :get_user_active_tasks, lambda { |user|

    user_ids = Usage::User.editables(user).map(&:id)
    user_ids << user.id

    joins(:status=>[:crm_case]).joins(:created)
    .where("crm_system_tasks.created_by in (?)", user_ids.uniq)
  }

  scope :completed_tasks, lambda { where("completed_at is not NULL") }
  scope :incomplete_tasks, lambda { where("completed_at is NULL OR completed_at=?", '') }

  scope :search_system_tasks, lambda { |str|
    joins(:crm_connection).
    joins("LEFT JOIN usage_users AS task_usage_users ON task_usage_users.id = crm_system_tasks.assigned_to_id")
    .where("crm_connections.first_name =? OR crm_connections.last_name =? OR
      task_usage_users.first_name =? OR task_usage_users.last_name =?", str, str, str, str)
  }

  before_save :set_due_at_field, :create_activity

  def dial_phone
    #need to implement
  end

  def print_letter
    #need to implement
  end

  def send_email
    begin
      message_body = self.marketing_email_template.apply(self.crm_connection.agent, self.crm_connection.profile, nil, {'connection' => self.crm_connection, 'case' => self.status.case})
      subject = self.marketing_email_template.subject
      if self.task_type.name == 'email'
        recipient = self.recipient.blank? ? self.crm_connection.email : self.recipient
      else
        recipient = self.recipient.blank? ? self.crm_connection.agent.email : self.recipient
      end
      attachments = [self.marketing_email_template.thumbnail]
      # SEND EMAIL CODE HERE
      unless recipient.blank?
        send_email_message(recipient, message_body, subject, attachments)
      else
        message_body = "For agent ID #{self.crm_connection.agent.id}: \n\n No e-mail addresses provided for Connection ID #{self.crm_connection.id}, so Task ID #{self.id} could not be completed. (Nevertheless, it was marked complete so that this process shall not be repeated. \n\n You can add contact info to this Connection and then mark the task incomplete to have the message sent."
        attachments = nil
        subject = "System Task couldn't be completed"
        if self.crm_connection.agent.email.blank?
          recipient = self.crm_connection.agent.email
          send_email_message(recipient, message_body, subject, attachments)
        else
          recipient = APP_CONFIG['error_email_recipient']
          send_email_message(recipient, message_body, subject, attachments)
        end
      end
    rescue Exception
    end
  end

  def send_recorded_call
    #need to implement
  end

  def send_sms_text
    #need to implement
  end

  def get_template
    crm_system_task_type = Crm::SystemTaskType.find_by_id(self.task_type_id)
    crm_system_task_type_name = crm_system_task_type.try(:name).try(:downcase)
    template = if ["email", "email agent"].include?(crm_system_task_type_name)
                 Marketing::Email::Template.find_by_id(self.template_id)
               elsif ["letter"].include?(crm_system_task_type_name)
                 Marketing::SnailMail::Template.find_by_id(self.template_id)
               elsif ["phone dial", "phone broadcast", "sms", "sms agent"].include?(crm_system_task_type_name)
                 Marketing::MessageMedia::Template.find_by_id(self.template_id)
               end
    template
  end

  def template_name
    template = self.get_template
    template.try(:name)
  end

  def template_name=(name)
    #need to implement
  end

  def set_due_at_field
    self.due_at = DateTime.strptime(self.due_at_date, "%m/%d/%Y") if !self.due_at_date.blank?
  end

  private

  def send_email_message(recipient, message_body, subject, attachments)
    mail = UserMailer.email_template_message(recipient, message_body, subject, attachments)
    custom = ::Mail.new(mail)
    custom.delivery_method(:smtp, self.created.get_current_smtp_setting)
    if custom.deliver
      self.completed_at = Time.now
    end
  end

  def create_activity
    if completed_at_changed? and completed_at.present?
      activity_owner_id = @curr_user.blank? ? self.assigned_to_id : @curr_user.id
      Crm::Activity.create(:description=>self.label, :owner_id=>activity_owner_id,
        :activity_type_id=>Crm::ActivityType.find_type_by_task_type_name(self.task_type.try(:name)).try(:id),
        :connection_id=>self.try(:status).try(:case).try(:connection_id))
    end
  end
end
