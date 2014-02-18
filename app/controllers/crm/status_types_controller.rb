class Crm::StatusTypesController < Crm::CrmBaseController
  def index
    @status_types = Crm::StatusType::all(current_user).sort_by{|status_type| status_type.sort_order.to_i}
    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def new
    @status_types = Crm::StatusType.new
    @ownerships = Ownership.all
    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def create
    status_type = Crm::StatusType.create(params[:crm_status_type].merge(owner_id: current_user.id))
    @status_types = Crm::StatusType::all(current_user).sort_by{|status_type| status_type.sort_order.blank? ? 0 : status_type.sort_order}
  end

  def edit
    @status_type = Crm::StatusType.find(params[:id])
    @ownerships = Ownership.all
    respond_to do | format |
      format.js {render :layout => false}
    end
  end

  def update
    @status_type = Crm::StatusType.find(params[:id])
    if @status_type.update_attributes(params[:crm_status_type])
      @status_types = Crm::StatusType::all(current_user).sort_by{|status_type| status_type.sort_order.blank? ? 0 : status_type.sort_order}
      respond_to do | format |
        format.js {render :layout => false}
      end
    end
  end
end
