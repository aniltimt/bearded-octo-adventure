class MarketingMailer < ActionMailer::Base
  default from: "from@example.com"

  def execute_marketing_task(recipient, message_body, subject, attachments = nil)
    @message_body = message_body
    message.attachments.each do |attach|
      unless attach.file_file_name.blank?
        attachments[attach.file_file_name] = File.read(attach.file.path)
      end
    end
    mail :to => recipient, :subject => subject
  end

end
