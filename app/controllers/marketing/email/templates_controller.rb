class Marketing::Email::TemplatesController < Marketing::MarketingBaseController

  autocomplete :marketing_email_templates, :name, :class_name => 'Marketing::Email::Template'
    
  def new
    @template = current_user.marketing_email_templates.build
  end
  
  def create
    @template = current_user.marketing_email_templates.build(params[:marketing_email_template])
    respond_to do |format|
      if @template.save
        format.js {}
        format.html { 
          flash[:notice] = "Successfully Created."
          redirect_to marketing_email_template_path( @template )
        }
      else
        format.js {}
        format.html {
          flash[:notice] = "Not Created."
          render :action => "new"
        }
      end
    end
  end
  
  def edit
    @template = Marketing::Email::Template.find(params[:id])
  end
  
  def update
    @template = Marketing::Email::Template.find(params[:id])
    respond_to do |format|
      if @template.update_attributes(params[:marketing_email_template])
        format.js {}
        format.html { 
          flash[:notice] = "Successfully Updated."
          redirect_to marketing_email_template_path( @template )
        }
      else
        format.js {}
        format.html {
          flash[:notice] = "Not Updated."
          render :action => "new"
        }
      end
    end
  end
  
  def index
    @templates = current_user.marketing_membership.readable_email_templates
    current_user_templates = current_user.marketing_email_templates
    @current_user_templates = current_user_templates.paginate(page: params[:page], per_page: 10,
                                              total_entries: current_user_templates.length)
  end
  
  def show
    @template = Marketing::Email::Template.find(params[:id])
  end

  def destroy
    @template = Marketing::Email::Template.find(params[:id])
    respond_to do |format|
      if @template.update_attributes(:enabled => false)
        format.js { render :text => ";$('#flash-container').html('Successfully Deleted');" }
        format.html { 
          flash[:notice] = "Successfully Deleted."
          redirect_to marketing_snail_mail_template_path( @template )
        }
      else
        format.js { render :text => ";$('#flash-container').html('Not Deleted.');", :status => 203 }
        format.html {
          flash[:notice] = "Not Deleted."
          render :action => "new"
        }
      end
    end
  end
  
  def template_liquid_options
    @results = Marketing::Email::Template.template_body_dynamic_options.collect do |x| 
      x if x[:value].to_s.include? params[:term]
    end
    respond_to do |format|
        format.json { render :json => @results.compact.to_json }
    end
  end
  
  def clone_template
    @old_template = Marketing::Email::Template.find(params[:existing_template_id])
    @template = @old_template.copy

    respond_to do |format|
      if @template.persisted?
        format.js {render :text => ";$('#flash-container').html('Successfully Created');"}
        format.html { 
          flash[:notice] = "Successfully Created."
          redirect_to marketing_snail_mail_template_path( @template )
        }
      else
        format.js  { render :text => ";$('#flash-container').html('Not Created.');", :status => 203 }
        format.html {
          flash[:notice] = "Not Created."
          render :action => "new"
        }
      end
    end
  end
  
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items = items.where(:owner_id => current_user.id)
  end
end
