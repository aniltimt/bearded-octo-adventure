class Usage::LeadDistributionWeightsController < ApplicationController

  def index
    if current_user.can_edit_user?( params[:agent_id] )
      tag_values = Tagging::TagValue.joins(:tag_keys, :tags).where("tagging_tag_keys.name = ?", "lead type")
      @agent_lead_distribution_weights = Usage::LeadDistributionWeight.joins(:tag_value).where(:agent_id => params[:agent_id])
      tag_values_without_weight = tag_values.map(&:id) - @agent_lead_distribution_weights.map(&:tag_value_id)
      tag_values_without_weight.each do |tag_value_id|
        @agent_lead_distribution_weights << Usage::LeadDistributionWeight.create(:agent_id => params[:agent_id], :tag_value_id => tag_value_id)
      end
    else
      @agent_lead_distribution_weights = []
    end
  end

  def update
    ldw = Usage::LeadDistributionWeight.find(params[:id])
    weight = params[:weight] || ldw.weight
    premium_limit = params[:premium_limit] || ldw.premium_limit
    respond_to do |format|
      if ldw && ldw.update_attributes(:weight => weight, :premium_limit => premium_limit)
        format.js { render :text => ";$('#flash-container').html('Successfully updated');" }
        format.html {}
      else
        format.js { render :text => ";$('#flash-container').html('Not updated successfully');", :status => 203 }
        format.html {}
      end
    end
  end

end
