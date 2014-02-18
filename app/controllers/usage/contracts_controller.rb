class Usage::ContractsController < ApplicationController
  
  autocomplete :usage_aml_vendor, :name, :class_name => "Usage::AmlVendor"
  def index
    @usage_contracts = Usage::Contract.all

    respond_to do |format|
      format.js 
    end
  end

  def new
    @usage_user = Usage::User.find_by_id(params[:id])
    @usage_contract = Usage::Contract.new
    @contract_carriers = Carrier.all
    @states = State.find(:all)
    @usage_contract_status = Usage::ContractStatus.all

    respond_to do |format|
      format.js 
    end
  end

  def edit
    @usage_contract = Usage::Contract.find(params[:id])
    @contract_carriers = Carrier.all
    @states = State.find(:all)
    @usage_contract_status = Usage::ContractStatus.all

     respond_to do |format|
      format.js {render :layout => false} 
    end
  end

  def create
    @usage_contract = Usage::Contract.new(params[:usage_contract])
    
    respond_to do |format|
      if @usage_contract.save
        @usage_contract = Usage::Contract.new
        @contract_carriers = Carrier.all
        @states = State.find(:all)
        @usage_contract_status = Usage::ContractStatus.all
        format.js {render :layout => false}
      else
        @contract_carriers = Carrier.all
        @states = State.find(:all)
        @usage_contract_status = Usage::ContractStatus.all
        
        format.js { render action: "new" }
      end
    end
  end
  
  def update
    @usage_contract = Usage::Contract.find(params[:id])

    respond_to do |format|
      if @usage_contract.update_attributes(params[:usage_contract])
       # @aml_vendor = Usage::AmlVendor.find(params[:id])
       # @usage_contract = @aml_vendor.contracts.new
        @usage_contract = Usage::Contract.new
        @contract_carriers = Carrier.all
        @states = State.find(:all)
        @usage_contract_status = Usage::ContractStatus.all

        format.js {render :layout => false} 
      else
        format.js { render action: "edit" }
      end
    end
  end

  def destroy
    @usage_contract = Usage::Contract.find(params[:id])
    @usage_contract.destroy
    @usage_contracts = Usage::Contract.all


    respond_to do |format|
      format.js {render :layout => false} 
    end
  end
end
