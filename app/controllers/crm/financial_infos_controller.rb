class Crm::FinancialInfosController < ApplicationController
  # GET /crm/financial_infos
  # GET /crm/financial_infos.json
  def index
    @crm_financial_infos = Crm::FinancialInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @crm_financial_infos }
    end
  end

  # GET /crm/financial_infos/1
  # GET /crm/financial_infos/1.json
  def show
    @crm_financial_info = Crm::FinancialInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @crm_financial_info }
    end
  end

  # GET /crm/financial_infos/new
  # GET /crm/financial_infos/new.json
  def new
    @crm_financial_info = Crm::FinancialInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @crm_financial_info }
    end
  end

  # GET /crm/financial_infos/1/edit
  def edit
    @crm_financial_info = Crm::FinancialInfo.find(params[:id])
  end

  # POST /crm/financial_infos
  # POST /crm/financial_infos.json
  def create
    @crm_financial_info = Crm::FinancialInfo.new(params[:crm_financial_info])

    respond_to do |format|
      if @crm_financial_info.save
        format.html { redirect_to @crm_financial_info, notice: 'Financial info was successfully created.' }
        format.json { render json: @crm_financial_info, status: :created, location: @crm_financial_info }
      else
        format.html { render action: "new" }
        format.json { render json: @crm_financial_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /crm/financial_infos/1
  # PUT /crm/financial_infos/1.json
  def update
    @crm_financial_info = Crm::FinancialInfo.find(params[:id])

    respond_to do |format|
      if @crm_financial_info.update_attributes(params[:crm_financial_info])
        format.html { redirect_to @crm_financial_info, notice: 'Financial info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @crm_financial_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crm/financial_infos/1
  # DELETE /crm/financial_infos/1.json
  def destroy
    @crm_financial_info = Crm::FinancialInfo.find(params[:id])
    @crm_financial_info.destroy

    respond_to do |format|
      format.html { redirect_to crm_financial_infos_url }
      format.json { head :no_content }
    end
  end
end
