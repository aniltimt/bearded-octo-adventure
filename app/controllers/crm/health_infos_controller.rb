class Crm::HealthInfosController < ApplicationController
  respond_to :html, :js, :json
  # GET /crm/health_infos
  # GET /crm/health_infos.json
  def index
    @crm_health_infos = Crm::HealthInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @crm_health_infos }
    end
  end

  # GET /crm/health_infos/1
  # GET /crm/health_infos/1.json
  def show
    @crm_health_info = Crm::HealthInfo.find(params[:id])
    respond_with @crm_health_info
  end

  # GET /crm/health_infos/new
  # GET /crm/health_infos/new.json
  def new
    @crm_health_info = Crm::HealthInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @crm_health_info }
    end
  end

  # GET /crm/health_infos/1/edit
  def edit
    @crm_health_info = Crm::HealthInfo.find(params[:id])
  end

  # POST /crm/health_infos
  # POST /crm/health_infos.json
  def create
    @crm_health_info = Crm::HealthInfo.new(params[:crm_health_info])

    respond_to do |format|
      if @crm_health_info.save
        format.html { redirect_to @crm_health_info, notice: 'Health info was successfully created.' }
        format.json { render json: @crm_health_info, status: :created, location: @crm_health_info }
      else
        format.html { render action: "new" }
        format.json { render json: @crm_health_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /crm/health_infos/1
  # PUT /crm/health_infos/1.json
  def update
    @crm_health_info = Crm::HealthInfo.find(params[:id])

    respond_to do |format|
      if @crm_health_info.update_attributes(params[:crm_health_info])
        format.html { redirect_to @crm_health_info, notice: 'Health info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @crm_health_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crm/health_infos/1
  # DELETE /crm/health_infos/1.json
  def destroy
    @crm_health_info = Crm::HealthInfo.find(params[:id])
    @crm_health_info.destroy

    respond_to do |format|
      format.html { redirect_to crm_health_infos_url }
      format.json { head :no_content }
    end
  end
end
