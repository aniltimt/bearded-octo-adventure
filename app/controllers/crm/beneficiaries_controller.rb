class Crm::BeneficiariesController < Crm::CrmBaseController

  before_filter :require_crm_case

  def index
    @primary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>false)
    @secondary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>true)
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def new
    @crm_beneficiary = Crm::Beneficiary.new()
    @crm_beneficiary.contingent = params[:beneficiary_type]=="secondary" ? true : false
    respond_to do |format|
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
        render :layout => false
      }
    end
  end

  def create
    @crm_beneficiary = Crm::Beneficiary.new(params['crm_beneficiary'])
    @crm_beneficiary.case_id = @crm_case.id
    respond_to do |format|
      if @crm_beneficiary.save
        @primary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>false)
        @secondary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>true)
        format.js {
          @container_to_be_replaced = container_to_be_used(params[:container_id])
        }
      else
        format.js { render :text => ";$('#flash-error').html('Not Created');", :status => 203 }
      end
    end
  end

  def edit
    @crm_beneficiary = @crm_case.beneficiaries.find_by_id(params[:id])
    respond_to do |format|
      format.js {
        @container_to_be_replaced = container_to_be_used(params[:container_id])
      }
      format.html {}
    end
  end

  def update
    @crm_beneficiary = @crm_case.beneficiaries.find_by_id(params[:id])
    respond_to do |format|
      if @crm_beneficiary && @crm_beneficiary.update_attributes(params['crm_beneficiary'])
        @primary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>false)
        @secondary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>true)
        format.js {
          @container_to_be_replaced = container_to_be_used(params[:container_id])
        }
      else
        format.js { render :text => ";$('#flash-notice').html('Not updated');", :status => 203 }
      end
    end
  end

  def destroy
    @crm_beneficiary = @crm_case.beneficiaries.find_by_id(params[:id])
    respond_to do |format|
      if @crm_beneficiary && @crm_beneficiary.destroy
        @primary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>false)
        @secondary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>true)
        format.js {
          @container_to_be_replaced = container_to_be_used(params[:container_id])
        }
      else
        format.js { render :text => ";$('#flash-notice').html('Not able to delete');", :status => 203 }
      end
    end
  end

  def update_attributes
    @crm_beneficiary = @crm_case.beneficiaries.find_by_id(params['pk'])
    if @crm_beneficiary && @crm_beneficiary.update_attribute(params['name'], params['value'])
      respond_to do |format|
        format.js { render :text => ";$('#flash-notice').html('Successfully updated');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-notice').html('Not updated successfully');", :status => 203 }
        format.html {}
      end
    end
  end

  def update_percentages
    @primary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>false)
    @secondary_crm_beneficiaries = @crm_case.beneficiaries.where(:contingent=>true)

    primary_percentages = params[:primary_percentages].to_s.split(",")
    i=0
    @primary_crm_beneficiaries.each do |beneficiary|
      beneficiary.update_attribute(:percentage, primary_percentages[i].to_i)
      i=i+1;
    end

    secondary_percentages = params[:secondary_percentages].to_s.split(",")
    i=0
    @secondary_crm_beneficiaries.each do |beneficiary|
      beneficiary.update_attribute(:percentage, secondary_percentages[i].to_i)
      i=i+1;
    end

    respond_to do |format|
      format.js { render :text => ";$('#flash-notice').html('Successfully updated');" }
      format.html {}
    end
  end
end
