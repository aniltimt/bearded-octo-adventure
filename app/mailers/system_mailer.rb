class SystemMailer < ActionMailer::Base
	default from:APP_CONFIG['email']['sender'], to:APP_CONFIG['email']['admin']

	def suggestion_email(suggestion)
		@suggestion = suggestion
		mail to:APP_CONFIG['email']['admin'], subject:"Suggestion from CLU2 User"
	end

  def error_email exception, additional_message=nil
    @exception = exception,
    @message = additional_message
    mail to:APP_CONFIG['email']['developers'], subject:'CLU2 Exception'
  end

  def no_agent_assignment_email kase, additional_message=nil
    @case = kase
    @message = additional_message
    mail to:APP_CONFIG['email']['admin'], subject:"No agent assigned for case ##{@case.id}"
  end
end
