class Usage::NotesController < ApplicationController

  before_filter :require_login
  before_filter :require_editable_permission, :except => [:index]

  def index
    @usage_user = Usage::User.find_by_id(params[:user_id])
    if @usage_user.present? && current_user.can_view_user?(@usage_user)
      @usage_notes = @usage_user.usage_notes
      respond_to do | format |
        format.js {
          @container_to_be_replaced = params[:container_id]
          render :layout => false
        }
        format.html{
          render :layout => "application"
        }
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-notice').html('You do not have permission');", :status => 401 }
        format.html {
          flash[:notice] = "You do not have permission"
          redirect_to :root
        }
      end
    end
  end

  def new
    @new_usage_note = Usage::Note.new
    render :layout => false
  end

  def create
    @new_usage_note = Usage::Note.new(params[:usage_note])
    @new_usage_note.user_id = @usage_user.id
    @new_usage_note.creator_id = current_user.id
    if @new_usage_note.save
      respond_to do |format|
        format.js { render :text => ";$('#flash-notice').html('Note Successfully Created');" }
        format.html {}
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-error').html('validation failed');", :status => 401 }
        format.html {}
      end
    end
  end

  def edit
    @usage_note = @usage_user.usage_notes.find_by_id(params[:id])
    render :layout => false
  end

  def destroy
    @usage_note = @usage_user.usage_notes.find_by_id(params[:id])
    @usage_note.destroy
    @usage_notes = @usage_user.usage_notes
    respond_to do | format |
        format.js {
          @container_to_be_replaced = params[:container_id]
          render :layout => false
        }
        format.html{
          render :layout => "application"
        }
    end
  end

  def update
    @usage_note = @usage_user.usage_notes.find_by_id(params[:id])
    respond_to do |format|
      if @usage_note.update_attributes(params[:usage_note])
        format.js { render :text => ";$('#flash-notice').html('Note Successfully Updated');" }
        format.html {}
      end
    end
  end

private

  def require_editable_permission
    @usage_user = Usage::User.find_by_id(params[:user_id])
    unless current_user.can_edit_user?(@usage_user)
      respond_to do |format|
       format.js {render 'home/permission_denied', :status=>401}
      end
    end
  end

end
