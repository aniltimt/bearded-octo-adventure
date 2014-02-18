class LeadsController < ApplicationController

  def diag
    respond_to do |format|
      format.html { render text: YAML::dump(params) }
      format.js { render json: params.to_json }
    end
  end

end