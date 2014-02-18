class Crm::CrmBaseController < ApplicationController

  before_filter :require_login

private

  def require_crm_case
    @crm_case = Crm::Case.find_by_id(params[:case_id] || params[:id])
    unless @crm_case.try(:viewable?, current_user)
      permission_denied
    end
  end

  def require_crm_connection
    @crm_connection = if params[:case_id].present?
      @crm_case = Crm::Case.find_by_id(params[:case_id])
      @crm_case.try(:crm_connection)
    else
      Crm::Connection.find_by_id(params[:connection_id] || params[:id])
    end
    unless @crm_connection.try(:viewable?, current_user)
      permission_denied
    end
  end

end
