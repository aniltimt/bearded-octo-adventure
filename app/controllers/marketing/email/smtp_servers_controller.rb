class Marketing::Email::SmtpServersController < Marketing::MarketingBaseController
  
  before_filter :smtp_server_existance, :only => [:new]  
  
  def new
    membership = current_user.marketing_membership
    @smtp_server = Marketing::Email::SmtpServer.new
  end

  def create
    params[:marketing_email_smtp_server][:owner_id] = current_user.id
    respond_to do |format|
      @smtp_server = current_user.marketing_membership.smtp_servers.build(params[:marketing_email_smtp_server])
      if @smtp_server.save
        @smtp_servers = current_user.smtp_servers
        format.js{}
        format.html{ redirect_to :action => :index }
      else
        format.js{}
        format.html{
          render :action => :new
        }
      end
    end 
  end

  def index
    @smtp_servers = current_user.smtp_servers
  end

  def edit
    @smtp_server = Marketing::Email::SmtpServer.find(params[:id])
    respond_to do |format|
      if current_user.smtp_servers.include?(@smtp_server)
        format.js{}
        format.html{}
      else
        format.js { render :text => ";$('#flash-error').html('You do not have permission to create smtp server');"}
        format.html{
          flash[:error] = 'You do not have permission to perform this action.'
          return;
        }
      end
    end 
  end

  def update
    @smtp_server = Marketing::Email::SmtpServer.find(params[:id])
    respond_to do |format|
      if current_user.smtp_servers.include?(@smtp_server)
        if @smtp_server && @smtp_server.update_attributes(params[:marketing_email_smtp_server])
          @smtp_servers = current_user.smtp_servers
          format.js{}
          format.html{ redirect_to :action => :new }
        else
          format.js{}
          format.html{
            render :action => :edit
          }
        end
      else
        format.js { render :text => ";$('#flash-error').html('You do not have permission to create smtp server');"}
        format.html{
          flash[:error] = 'You do not have permission to perform this action.'
          return;
        }
      end
    end 
  end

  def destroy
    smtp_server = Marketing::Email::SmtpServer.find(params[:id])
    respond_to do |format|
      if current_user.smtp_servers.include?(smtp_server)
        if smtp_server.destroy
          @smtp_server = Marketing::Email::SmtpServer.new
         # @smtp_servers = current_user.smtp_servers
          format.js{
          }
          format.html{ redirect_to :action => :new }
        else
          format.js{
            render :text => ";$('#flash-container').html('Somthing went wrong.');"
          }
          format.html{
            @smtp_server = smtp_server
            falsh[:error] = "Somthing went wrong."
            redirect_to :action => :edit
          }
        end
      else
        format.js { render :text => ";$('#flash-error').html('You do not have permission to create smtp server');"}
        format.html{
          flash[:error] = 'You do not have permission to perform this action.'
          return;
        }
      end
    end
  end
  
  private
  
  def smtp_server_existance
    unless current_user.smtp_servers.blank?
      respond_to do |format|
        @smtp_server = current_user.smtp_servers.first
        format.js {render :action => :edit}
        format.html {render :action => :edit}
      end
    end
  end

end
