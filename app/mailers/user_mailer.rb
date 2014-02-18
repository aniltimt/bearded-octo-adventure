class UserMailer < ActionMailer::Base

  default from: "from@example.com"

  def password_reset(user, email)
    @user = user
    mail :to => email do |format|
      format.html
    end
  end

  def email_message(message, message_body)
    @message_body = message_body.html_safe
    message.attachments.each do |attach|
      unless attach.file_file_name.blank?
        attachments[attach.file_file_name] = File.read(attach.file.path)
      end
    end
    mail :to => receiver_emails(message) , :subject => message.subject.blank? ? message.template.subject : message.subject do |format|
      format.html
    end
  end

  def email_template_message(recipient, message_body, subject, attachments = nil)
    @message_body = message_body
    message.attachments.each do |attach|
      unless attach.file_file_name.blank?
        attachments[attach.file_file_name] = File.read(attach.file.path)
      end
    end
    mail :to => recipient, :subject => subject do |format|
      format.html
    end
  end

  def super?
    ['admin','developer'].include? self.role.name
  end

  def task_has_no_assignment_notification(agent, task)
    @task = task
    mail :to => agent.email, :subject => "Task has no assigned user" do |format|
      format.html
    end
  end

  private

  def user_email(message)
    unless message.user.blank?
      unless message.user.contact_info.blank?
        message.user.contact_info.emails.blank? ? nil : message.user.contact_info.emails.first
      end
    end
  end

  def connection_email(message)
    unless message.crm_connection.blank?
      unless message.crm_connection.contact_info.blank?
        message.crm_connection.contact_info.emails.blank? ? nil : message.crm_connection.contact_info.emails.first
      end
    end
  end

  def receiver_emails(message)
    emails = []
    connection_email = connection_email(message)
    user_email = user_email(message)
    emails << connection_email.value unless connection_email.try(:value).blank?
    emails << user_email.value unless user_email.try(:value).blank?
    emails << message.recipient unless message.recipient.blank?
    return emails.join(',')
  end

end
