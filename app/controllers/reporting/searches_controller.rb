class Reporting::SearchesController < Reporting::SearchBaseController
  autocomplete :usage_user, :login, :class_name => "Usage::User"
  autocomplete :usage_role, :name, :class_name => "Usage::Role"
  autocomplete :usage_user, :first_name, :class_name => "Usage::User"

  before_filter :check_user_membership
  before_filter :membership_canned_report_status, :only => [:show]
  before_filter :membership_custom_report_status, :only => [:new, :create, :edit, :destroy, :update]
  require 'will_paginate/array'

  
  def index 
    @reporting_searches = Reporting::Search::all(current_user)

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
    
  def new
    unless params[:id].blank?
      @copy_search = Reporting::Search.find(params[:id])
    end
    @reporting_search = Reporting::Search.new

      respond_to do |format|
        format.js {render :layout => false}
      end
   end
   
  def create
    @reporting_search = Reporting::Search.new(params[:reporting_search]) 
    @reporting_search.owner_id = current_user.id
    @reporting_search.ownership_id = current_user.id
     
    respond_to do |format|
      if @reporting_search.save
        @reporting_searches = Reporting::Search::all(current_user)
        format.js {render :layout => false}
      else
        format.js { render action: "new" }
      end
    end  
  end
   
  def edit
    unless params[:id].blank?
      @copy_search = Reporting::Search.find(params[:id])
    end
    @reporting_search = Reporting::Search.find(params[:id])
     
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
    
  def results
    @reporting_search = Reporting::Search.find(params[:id])
    if @reporting_search.viewable?(current_user)
      @crm_cases = Crm::Case.parse_to_scope(@reporting_search.query)
    else
      return render 'home/permission_denied', :layout => false, :status => 401
    end

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
    
  def update
    @reporting_search = Reporting::Search.find(params[:id])
      
    respond_to do |format|
      if @reporting_search.update_attributes(params[:reporting_search])
        @reporting_searches = Reporting::Search::all(current_user)
        format.js {render :layout => false}
      else
        format.js { render action: "edit" }
      end
    end
  end
    
  def show
    @reporting_search = Reporting::Search.find(params[:id])
      
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  def destroy
    @reporting_search = Reporting::Search.find(params[:id])
    @reporting_search.destroy
    @reporting_searches = Reporting::Search::all(current_user)

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
    
  def legacy_new
    @legacy_search = Reporting::LegacySearch.new
    @states = State.find(:all)
    @campaigns = Marketing::Campaign.all
    @profiles = Usage::Profile.all(current_user)
    @policies = Crm::PolicyType.all
    @openness = Crm::Openness.all()
    @status = Crm::StatusType.all(current_user)
      
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def legacy_edit
    @legacy_search = Reporting::LegacySearch.find(params[:id])
    @states = State.find(:all)
    @campaigns = Marketing::Campaign.all
    @profiles = Usage::Profile.all(current_user)
    @policies = Crm::PolicyType.all
    @openness = Crm::Openness.all()
    @status = Crm::StatusType.all(current_user)

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  def legacy_update
    if params["commit"] == "Save Search"
      @legacy_search = Reporting::LegacySearch.find(params[:id])

      respond_to do |format|
        if @legacy_search.update_attributes(params[:reporting_legacy_search])
          format.js { render :text => ";$('#flash-container').html('Legacy Search Successfully Updated');"}
        else
          format.js { render action: "legacy_edit" }
        end
      end
    else
      conditions = ReportingSearchConditions.new.parse_search_param_string(params)
      crm_connections = Crm::Connection.find(:all, :joins => conditions.joins, :conditions => conditions.conditions)
      crm_connections = crm_connections.uniq
      @crm_connections = crm_connections.paginate(:page => params[:page], :per_page => 10, :total_entries => crm_connections.length)

      respond_to do |format|
        format.js {render :layout => false}
      end
    end 
  end

  def legacy_index
    @legacy_searches = Reporting::LegacySearch.all(current_user)

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def legacy_results
    if params["commit"] == "Save Search"
      @legacy_search = Reporting::LegacySearch.new(params[:reporting_legacy_search]) 
      @legacy_search.owner_id = current_user.id
      @legacy_search.ownership_id = current_user.id
     
      respond_to do |format|
        if @legacy_search.save
          format.js { render :text => ";$('#flash-container').html('Legacy Search Successfully saved');"}
        else
          format.js { render action: "legacy_new" }
        end
      end  
    else
      conditions = ReportingSearchConditions.new.parse_search_param_string(params)
      crm_connections = Crm::Connection.find(:all, :joins => conditions.joins, :conditions => conditions.conditions)
      crm_connections = crm_connections.uniq
      @crm_connections = crm_connections.paginate(:page => params[:page], :per_page => 10, :total_entries => crm_connections.length)

      respond_to do |format|
        format.js {render :layout => false}
      end
    end 
  end

  def get_autocomplete_items(parameters)
    if (params[:action] == "autocomplete_usage_user_login")
      items = Usage::User.viewables(current_user)
    	items = items.where("login like '%#{params[:term]}%'")
    elsif (params[:action] == "autocomplete_usage_role_name")
      items = Usage::User::includes(:role).where('usage_roles.name = ?','sales support')
    	items = items.where("first_name like '%#{params[:term]}%' || last_name like '%#{params[:term]}%'")
    elsif (params[:action] == "autocomplete_usage_user_first_name")
      items = Usage::User.joins(:role).where("usage_roles.name = 'sales agent'")
    	items = items.where("first_name like '%#{params[:term]}%'")
    else
      return
    end
  end  
end