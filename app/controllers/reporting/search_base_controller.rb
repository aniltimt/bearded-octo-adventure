class Reporting::SearchBaseController < ApplicationController
  
  before_filter :require_login
  
  private

    def check_user_membership
      @reporting_membership = Reporting:: Membership.find_by_owner_id(current_user.id)
      if @reporting_membership
        return true
      else  
        permission_denied
      #  return render 'application/permission_denied', :layout => false, :status => 401
      end
    end 
  
  def membership_canned_report_status
    if @reporting_membership.canned_reports_privilege
      return true
    else
      permission_denied
    #  return render 'home/permission_denied', :layout => false, :status => 401
    end  
  end
  def membership_custom_report_status
    if @reporting_membership.custom_reports_privilege
      return true
    else
      permission_denied
      return render 'home/permission_denied', :layout => false, :status => 401
    end  
  end
end