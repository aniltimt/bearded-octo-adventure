class PhoneController < ContactInfoController

  before_filter :require_contact_info, :only => [:new, :edit, :update]

  def new
    @phone = @contact_info.phones.build
    render :layout => false
  end

  def create
    @phone = Phone.create(params[:phone])
    if @phone.save
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

  def edit
    @phone = @contact_info.phones.find_by_id(params[:id])
    render :layout => false
  end

  def update
    @phone = @contact_info.phones.find_by_id(params[:id])
    if @phone && @phone.update_attributes(params['phone'])
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

  def get_phone_type
    @phone_types = PhoneType.all
    render :json => @phone_types.map{|p| {'value'=> p.id, 'text'=> p.name.try(:capitalize)+":"}}
  end
end
