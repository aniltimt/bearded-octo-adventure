class ContactInfoController < ApplicationController

  before_filter :require_login
  before_filter :require_contact_info, :only => [:update]

  def update
    if @contact_info && @contact_info.update_attribute(params['name'], params['value'])
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

  private

  def require_contact_info
    if params[:connection_id].present?
      @crm_connection = Crm::Connection.find_by_id(params[:connection_id])
      if @crm_connection.editable?(current_user)
        if @crm_connection.contact_info
          @contact_info = @crm_connection.contact_info
        else
          @contact_info = ContactInfo.create
          @crm_connection.update_attribute(:contact_info_id, @contact_info.id)
        end
      end
    elsif params[:user_id].present?
      if current_user.can_edit_user?(params[:user_id])
        @usage_user = Usage::User.find_by_id(params[:user_id])
        if @usage_user.contact_info
          @contact_info = @usage_user.contact_info
        else
          @contact_info = ContactInfo.create
          @usage_user.update_attribute(:contact_info_id, @contact_info.id)
        end
      end
    else
      @contact_info = ContactInfo.find_by_id(params[:contact_info_id])
    end
    unless @contact_info.present?
      return render 'home/permission_denied', :layout => false, :status => 401
    end
  end
end
