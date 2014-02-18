class HelpController < ApplicationController

	def post_suggestion
		SystemMailer.suggestion_email(params[:suggestion]).deliver

		respond_to do |format|
 			format.js { render :text => ";$('#flash-container').html('Your suggestion was sent!');", :status => 200 }
			format.html { redirect_to(:back, :notice => 'Your suggestion was sent!') }
		end
	end

end
