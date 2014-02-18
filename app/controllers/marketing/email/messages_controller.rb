class Marketing::Email::MessagesController < Marketing::MarketingBaseController

  def index
    @messages = current_user.email_messages
  end

  def new
    @message = current_user.email_messages.build
    @message.attachments.build
  end

  def create
    unless params[:marketing_email_message][:template_id].blank?
      params[:marketing_email_message][:body] = ""
    end
    @message = current_user.email_messages.build(params[:marketing_email_message])
    respond_to do |format|
        if @message.save
          @messages = current_user.email_messages
          if params[:marketing_email_message][:send_email_message] == 'Send'
            unless receiver_emails(@message).blank?
              @message.send_email
              unless @message.reload.sent.blank?
                @msg = "Email message sent successfully."
              else
                @msg = "Something is wrong with your smtp setting."
              end
              format.js{}
              format.html{ redirect_to :action => :index }
            else
              @msg = "Successfully created but not sent because any of your receiver does not have email address."
              format.js{
              }
              format.html{
                flash[:error] = @msg
                render :action => :new
              }
            end
          else
            @msg = "Created successfully."
            format.js{}
            format.html{}
          end
        else
          format.js{}
          format.html{
            render :action => :new
          }
        end
    end
  end

  def edit
    @message = current_user.email_messages.find_by_id(params[:id])
    @messages = current_user.email_messages
    if @message.attachments.blank?
      @message.attachments.build
    end
    respond_to do |format|
      unless @message
        format.js{
          render :text => ";$('#flash-error').html('You do not have permission to edit message');", :status => 401
        }
        format.html{
          flash[:error] = "You do not have permission to edit message."
          redirect_to :action => :index
        }
      else
        format.js{}
      end
    end
  end

  def update
    unless params[:marketing_email_message][:template_id].blank?
      params[:marketing_email_message][:body] = ""
    end
    @message = current_user.email_messages.find_by_id(params[:id])
    respond_to do |format|
      if @message.sent.blank? && @message.update_attributes(params[:marketing_email_message])
        @messages = current_user.email_messages
        if params[:marketing_email_message][:send_email_message] == 'Send'
          unless receiver_emails(@message).blank?
            @message.send_email
            unless @message.reload.sent.blank?
              @msg = "Email message sent successfully."
            else
              @msg = "Something is wrong with your smtp setting."
            end
            format.js{}
            format.html{
              redirect_to :action => :index
            }
          else
            @msg = "Successfully updated but not sent because any of your receiver does not have email address."
            format.js{
            }
            format.html{
              flash[:error] = @msg
              render :action => :edit
            }
          end
        else
          @msg = "Updated successfully."
          format.js{}
          format.html{}
        end
      else
        format.js{}
        format.html{
          render :action => :edit
        }
      end
    end
  end

  def destroy
    @message = current_user.email_messages.find_by_id(params[:id])
    respond_to do |format|
      if @message.sent.blank? && @message.destroy
        @messages = current_user.email_messages
        format.js{}
        format.html{
          redirect_to :action => :index
        }
      else
        format.js{
          render :text => ";$('#flash-container').html('Something is wrong with your smtp setting.');", :status => 401
        }
        format.html{
          falsh[:error] = "Something is wrong with your smtp setting."
          redirect_to :action => :index
        }
      end
    end
  end

  def send_message
    @message = current_user.email_messages.find_by_id(params[:id])
    respond_to do |format|
      unless receiver_emails(@message).blank?
        if @message.send_email
          @messages = current_user.email_messages
          format.js{}
          format.html{
            redirect_to :action => :index
          }
        else
          format.js{
            render :text => ";$('#flash-container').html('Something is wrong with your smtp setting.');", :status => 401
          }
          format.html{
            falsh[:error] = "Something is wrong with your smtp setting."
            redirect_to :action => :index
          }
        end
      else
        format.js{
          render :text => ";$('#flash-container').html('Not sent because any of your receiver does not have email address.');", :status => 401
        }
        format.html{
          falsh[:error] = "Not sent because any of your receiver does not have email address."
          redirect_to :action => :index
        }
      end
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
    emails << connection_email unless connection_email.blank?
    emails << user_email unless user_email.blank?
    emails << message.recipient unless message.recipient.blank?
    return emails.join(',')
  end

  def send_email_message(message)
    message.send_email
  end

end
