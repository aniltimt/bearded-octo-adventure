class Crm::ActivitiesController < ApplicationController

  before_filter :require_login

  def index
    if params[:mgr].present?
      crm_activities = Crm::Activity.viewables(current_user).uniq
    else
      crm_activities = current_user.activities
    end

    if params["activities-date-range-field"]
      crm_activities = crm_activities.where(:created_at => Date.parse(params[:from_date])..Date.parse(params[:to_date]))
    end

    @crm_activities = crm_activities.paginate(page: params[:page], per_page: 10,
                                              total_entries: crm_activities.length)
  end

  def update
    @activity = Crm::Activity.find(params[:id])
    if params[:name] == "created_at"
      datetime_conversion( params[:value] )
    end
    respond_to do |format|
      if @activity && @activity.update_attributes(params[:name] => params[:value])
        @update_status_text = 'Successfully updated'
        format.js {}
        format.html {}
      else
        @update_status_text = 'Not updated successfully'
        format.js {}
        format.html {}
      end
    end
  end

  def new
    @activity = current_user.activities.build(:connection_id => params[:connection_id], :user_id => current_user.id, :activity_type_id => Crm::ActivityType.find_by_name('other').id)
  end

  def edit
    @activity = Crm::Activity.find(params[:id])
  end

  def create
    params[:crm_activity][:activity_type_id] = Crm::ActivityType.find_by_name('other').id
    @activity = current_user.activities.build(params[:crm_activity])
    respond_to do |format|
      if @activity.save
        if params[:mgr].present?
          crm_activities = Crm::Activity.viewables(current_user).uniq
        else
          crm_activities = current_user.activities
        end

        @crm_activities = crm_activities.paginate(page: params[:page], per_page: 10,
                                                  total_entries: crm_activities.length)
        format.js { }
        format.html {
          flash[:notice] = "Account created."
          redirect_to :action => 'index'
        }
      else
        format.js { }
        format.html {
          render :action => 'new'
        }
      end
    end
  end

  def destroy
    @activity = Crm::Activity.find(params[:id])
    respond_to do |format|
      if @activity.destroy
        if params[:mgr].present?
          crm_activities = Crm::Activity.viewables(current_user).uniq
        else
          crm_activities = current_user.activities
        end

        @crm_activities = crm_activities.paginate(page: params[:page], per_page: 10,
                                                  total_entries: crm_activities.length)
        format.js {}
        format.html {
          flash[:notice] = "Activity deleted."
          redirect_to :action => 'index'
        }
      else
        format.js {}
        format.html {
          flash[:notice] = "Not deleted."
          redirect_to :action => 'index'
        }
      end
    end
  end

  def all_activity_statuses
    @activity_statuses = Crm::ActivityStatus.all
    render :json => @activity_statuses.map{|p| {'value'=> p.id, 'text'=> p.name}}
  end

  def activities_between_dates
    @crm_activities = current_user.activities.where(:created_at => Date.parse(params[:from_date])..Date.parse(params[:to_date]))
  end

  private

  def datetime_conversion( date_value )
    params[:value] = DateTime.parse( date_value )
  end

end
