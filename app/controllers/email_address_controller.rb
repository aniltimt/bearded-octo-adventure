class EmailAddressController < ContactInfoController

  before_filter :require_contact_info, :only => [:new, :update]

  def new
    @email_address = @contact_info.emails.build
    render :layout => false
  end

  def create
    @email_address = EmailAddress.create(params[:email_address])
    if @email_address.save
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Added Successfully');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('validation failed');", :status => 422 }
        format.html {}
      end
    end
  end

  def update
    @email = @contact_info.emails.find_by_id(params[:id])
    if @email && @email.update_attribute(params['name'], params['value'])
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not updated');", :status => 203 }
        format.html {}
      end
    end
  end
end
