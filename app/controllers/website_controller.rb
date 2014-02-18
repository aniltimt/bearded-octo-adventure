class WebsiteController < ContactInfoController

  before_filter :require_contact_info, :only => [:new, :update, :destroy]

  def new
    @website = @contact_info.websites.build
    render :layout => false
  end

  def create
    @website = Website.create(params[:website])
    if @website.save
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
    @website = @contact_info.websites.find_by_id(params[:id])
    if @website && @website.update_attribute(params['name'], params['value'])
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

  def destroy
    @website = @contact_info.websites.find_by_id(params[:id])

    if @website && @website.destroy
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Successfully deleted');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('Not deleted successfully');", :status => 203 }
        format.html {}
      end
    end
  end

end
