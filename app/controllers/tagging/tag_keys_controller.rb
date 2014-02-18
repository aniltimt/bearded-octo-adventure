class Tagging::TagKeysController < ApplicationController
  
  def index
    if !params[:user_id].blank?
      user = Usage::User.find(params[:user_id])
      @tags = user.tags
    elsif params[:connection_id]
      connection = Crm::Connection.find(params[:connection_id])
      @tags = connection.tags
    end
    respond_to do | format |  
      format.js {render :layout => false}  
    end
  end
  
  def home
    
  end
  
  def new
    @tag_key = Tagging::TagKey.new
    @ownerships = Ownership.all
    respond_to do | format |  
      format.js {render :layout => false}  
    end
  end
  
  def create
    tag_key = Tagging::TagKey.create(params[:tagging_tag_key])
    tag_key.owner_id = current_user.id
    tag_key.save
    @tag_keys = Tagging::TagKey.all
  end
  
  def edit
    @tag_key = Tagging::TagKey.find(params[:id])
    @ownerships = Ownership.all
    respond_to do | format |  
      format.js {render :layout => false}  
    end
  end
  
  def update
    @tag_key = Tagging::TagKey.find(params[:id])
    if @tag_key.update_attributes(params[:tagging_tag_key])  
        @tag_keys = Tagging::TagKey.all
         respond_to do | format |  
          format.js {render :layout => false}
         end
      end
  end
end
