class Usage::StaffAssignmentController < ApplicationController
  autocomplete :usage_user, :first_name, :class_name => "Usage::User"

  def index
    @staffs = Usage::StaffAssignment.all
    respond_to do |format|
      format.js   
      format.json { render json: @staffs }
    end
  end

  def new
    @staff_assignment = Usage::StaffAssignment.new
    respond_to do |format|
      format.js { render :layout => false}
      format.html { render :layout => true }
    end
  end
  
  def create
    if Usage::StaffAssignment.create(params[:usage_staff_assignment])
      flash[:notice] = "Staff Assignment done"
      redirect_to :root
    end
  end

  def edit
    @staff = Usage::StaffAssignment.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js {render :layout => false} 
    end
  end

  def update
    @staff = Usage::StaffAssignment.find(params[:id])
    respond_to do |format|
      if @staff.update_attributes(params[:usage_staff_assignment])
         @staff = Usage::StaffAssignment.new
	 @staffs = Usage::StaffAssignment.all
         format.js {render :layout => false} 
      else
         format.js { render action: "edit" }
      end
    end
  end
  
  def destroy
    @staff = Usage::StaffAssignment.find(params[:id])
    @staff.destroy
    @staffs = Usage::StaffAssignment.all
    respond_to do |format|
      format.js {render :layout => false} 
    end
  end

  def get_autocomplete_items(parameters)
    if (params[:role_name] == "administrative_assistant")
        role = Usage::Role.find_by_name('administrative assistant')
        items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])
    elsif (params[:role_name] == "case_manager")
        role = Usage::Role.find_by_name('case manager')
        items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])
    elsif (params[:role_name] == "manager")
        role = Usage::Role.find_by_name('manager')
        items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])
    elsif (params[:role_name] == "policy_specialist")
        role = Usage::Role.find_by_name('policy specialist')
        items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])
    elsif (params[:role_name] == "sales_assistant")
        role = Usage::Role.find_by_name('sales assistant')
        items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])
    elsif (params[:role_name] == "sales_coordinator")
        role = Usage::Role.find_by_name('sales coordinator')
        items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])
     elsif (params[:role_name] == "sales_support")
        role = Usage::Role.find_by_name('sales support')
       items = Usage::User.viewables(current_user).find(:all, :select => "first_name, id", :conditions => ["role_id=? and first_name like '%#{params[:term]}%'",role.id])                                                  
    end
  end
 
end
