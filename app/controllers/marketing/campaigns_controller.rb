class Marketing::CampaignsController < ApplicationController
  
  def index
    @marketing_campaigns = Marketing::Campaign.order("id DESC")

    respond_to do |format|
      format.js {render :layout => false} 
    end
  end

  def new
    @marketing_campaign = Marketing::Campaign.new
    @ownerships = Ownership.all

    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def edit
    @marketing_campaign = Marketing::Campaign.find(params[:id])
    @ownerships = Ownership.all

    respond_to do | format |  
      format.js {render :layout => false}  
    end
  end

  def create
    marketing_campaign = Marketing::Campaign.new(params[:marketing_campaign])
    marketing_campaign.owner_id = current_user.id
    marketing_campaign.save
    @marketing_campaigns = Marketing::Campaign.order("id DESC")
  end

  def update
    @marketing_campaign = Marketing::Campaign.find(params[:id])

      if @marketing_campaign.update_attributes(params[:marketing_campaign])
         @marketing_campaigns = Marketing::Campaign.order("id DESC")

         respond_to do |format|
           format.js {render :layout => false} 
         end
      end
  end

  def destroy
    @marketing_campaign = Marketing::Campaign.find(params[:id])
    @marketing_campaign.destroy
    @marketing_campaigns = Marketing::Campaign.order("id DESC")

    respond_to do |format|
      format.js {render :layout => false}
    end
  end
end
