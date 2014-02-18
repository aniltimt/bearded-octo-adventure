class AddressController < ContactInfoController

  before_filter :require_contact_info, :only => [:update]

  def update
    @address = @contact_info.addresses.find_by_id(params[:id])
    if @address && @address.update_attribute(params['name'], params['value'])
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
