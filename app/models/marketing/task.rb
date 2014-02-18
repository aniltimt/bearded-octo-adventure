class Marketing::Task < ActiveRecord::Base
  attr_accessible :campaign_id, :client_id, :system_task_id

  # Associations
  belongs_to :campaign
  belongs_to :client, :class_name => "Crm::Client"
  belongs_to :system_task, :class_name => "Crm::SystemTask", :dependent => :destroy

  def self.execute_auto_task_rules
    begin
      self.includes(:system_task).where("crm_system_tasks.due_at <=? AND crm_system_tasks.completed_at IS ? AND
                                      crm_system_tasks.task_type_id = ?", Time.now, nil, Crm::SystemTaskType.find_by_name('email').id).each do |task|    
        message_body = task.system_task.marketing_email_template.apply(task.system_task.crm_connection.agent, task.system_task.crm_connection.profile, nil, get_other_liquid_objects)
        subject = task.system_task.marketing_email_template.subject
        recipient = task.system_task.crm_connection.email
        unless recipient.blank?
          mail = MarketingMailer.execute_marketing_task(recipient, message_body, subject)
          custom = ::Mail.new(mail)
          custom.delivery_method(:smtp, task.campaign.owner.get_current_smtp_setting)
          if custom.deliver
            self.completed_at = Time.now
          end
        else
          message_body = "For agent ID #{task.system_task.crm_connection.agent.id}: \n\n No e-mail addresses provided for Connection ID #{task.system_task.crm_connection.id}, so Task ID #{task.system_task.id} could not be completed. (Nevertheless, it was marked complete so that this process shall not be repeated. \n\n You can add contact info to this Connection and then mark the task incomplete to have the message sent."
          attachments = nil
          subject = "System Task couldn't be completed"
          recipient = APP_CONFIG['error_email_recipient']
          send_email_message(recipient, message_body, subject, attachments)
        end
      end
    rescue Exception
    end
  end

  private

  def get_other_liquid_objects
    connection =  task.system_task.crm_connection
    agent = connection.agent
    agent_of_record = agent.agent_of_record
    return {'connection' => connection, 'today' => Date.today, 'agent_of_record' => agent_of_record.blank? ? agent : agent_of_record }
  end

end
