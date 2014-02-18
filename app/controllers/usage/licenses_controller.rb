class Usage::LicensesController < ApplicationController
 
 autocomplete :usage_user, :first_name, :class_name => "Usage::User"
  def index
    @usage_licenses = Usage::License.all

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def new
    @usage_user = Usage::User.find_by_id(params[:id])
    @usage_license = Usage::License.new
    @license_statuses = Usage::LicenseStatus.all
    @states = State.find(:all)
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def edit
    @usage_license = Usage::License.find(params[:id])
    @license_statuses = Usage::LicenseStatus.all
    @states = State.find(:all)

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end

  def create
    @usage_license = Usage::License.new(params[:usage_license])
    @usage_license.save
    @license_statuses = Usage::LicenseStatus.all
    @states = State.find(:all)
    respond_to do |format|
      if @usage_license.save
         @usage_license = Usage::License.new
        format.js {render :layout => false} 
      else
        format.js { render action: "new" }
      end
    end 
  end
  
  def update
    @usage_license = Usage::License.find(params[:id])

    respond_to do |format|
      if @usage_license.update_attributes(params[:usage_license])
        @usage_license = Usage::License.new
        @license_statuses = Usage::LicenseStatus.all
        @states = State.find(:all)
  
        format.js {render :layout => false}  
      else
        format.js { render action: "edit" }
      end
    end
  end

  def destroy
    @usage_license = Usage::License.find(params[:id])
    @usage_license.destroy
    @usage_licenses = Usage::License.all

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end
end
