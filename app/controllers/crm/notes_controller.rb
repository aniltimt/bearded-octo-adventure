class Crm::NotesController < Crm::CrmBaseController

  before_filter :require_crm_connection, :only => [:index, :new, :edit, :destroy]

  def index
    @crm_notes = Crm::Note.get_notes_except_note_type_exam(@crm_connection, current_user)
    respond_to do | format |
      format.js {
        render :layout => false
      }
      format.html{
        render :layout => "connection_summary"
      }
    end
  end

  def new
    @is_edit_page = params[:edit_page] == "true"
    @new_crm_note = Crm::Note.new
    render :layout => false
  end

  def create
    crm_connection = Crm::Connection.find(params[:crm_note][:connection_id])
    @new_crm_note = Crm::Note.new(params[:crm_note])
    @new_crm_note.user_id = current_user.id
    if crm_connection.editable?(current_user)
      if @new_crm_note.save
        respond_to do |format|
          format.js { render :text => ";$('#flash-container').html('Note Successfully Created');" }
          format.html {}
        end
      else
        respond_to do |format|
          format.js { render :text => ";$('#flash-container').html('validation failed');", :status => 422 }
          format.html {}
        end
      end
    else
      respond_to do |format|
        format.js { render :text => ";$('#flash-container').html('You do not have permission to create note');", :status => 401 }
        format.html {}
      end
    end
  end

  def edit
    @crm_note = Crm::Note.find(params[:id])
    render :layout => false
  end

  def destroy
    @crm_note = Crm::Note.find(params[:id])
    @crm_note.delete
    @crm_notes = Crm::Note.get_notes_except_note_type_exam(@crm_connection, current_user)
    respond_to do | format |
      format.js {
          render :layout => false
      }
      format.html{
        render :layout => "connection_summary"
      }
    end
  end

  def update
    @crm_note = Crm::Note.find(params[:crm_note][:id])
    @crm_note.user_id = current_user.id
      respond_to do |format|
        if @crm_note.update_attributes(params[:crm_note])
          format.js { render :text => ";$('#flash-container').html('Note Successfully Updated');" }
          format.html {}
        end
      end
  end
end
