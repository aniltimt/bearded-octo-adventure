class Marketing::SnailMail::MessagesController < Marketing::MarketingBaseController
  
  def index
    @messages = current_user.snail_mail_messages
  end
  
  def new
    @message = current_user.snail_mail_messages.build
  end

  def create
    unless params[:marketing_snail_mail_message][:template_id].blank?
      params[:marketing_snail_mail_message][:body] = ""
    end
    @message = current_user.snail_mail_messages.build(params[:marketing_snail_mail_message])
    respond_to do |format|
      if @message.save
        @messages = current_user.snail_mail_messages
        @msg = "Created successfully."
        format.js{}
        format.html{}
      else
        @msg = "Not Created."
        format.js{}
        format.html{
          render :action => :new
        }
      end
    end
  end
  
  def edit
    @message = current_user.snail_mail_messages.find_by_id(params[:id])
    @messages = current_user.snail_mail_messages
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
    unless params[:marketing_snail_mail_message][:template_id].blank?
      params[:marketing_snail_mail_message][:body] = ""
    end
    @message = current_user.snail_mail_messages.find_by_id(params[:id])
    respond_to do |format|
      if @message && @message.update_attributes(params[:marketing_snail_mail_message])
        @messages = current_user.snail_mail_messages
        @msg = "Updated successfully."
        format.js{}
        format.html{}
      else
        format.js{}
        format.html{
          render :action => :edit  
        }
      end
    end
  end
  
  def destroy
    @message = current_user.snail_mail_messages.find_by_id(params[:id])    
    respond_to do |format|
      if @message && @message.destroy
        @messages = current_user.snail_mail_messages
        format.js{}
        format.html{}
      else
        format.js{
          render :text => ";$('#flash-container').html('Somthing went wrong.');", :status => 401
        }
        format.html{
          falsh[:error] = "Somthing went wrong."
          redirect_to :action => :index
        }
      end
    end
  end
  
  def show
    @message = current_user.snail_mail_messages.find_by_id(params[:id])
    unless @message.blank?
      @message_body = @message.get_message_content
    end
  end
  
end
