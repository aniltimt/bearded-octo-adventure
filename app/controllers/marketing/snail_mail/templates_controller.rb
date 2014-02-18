class Marketing::SnailMail::TemplatesController < Marketing::MarketingBaseController

  autocomplete :marketing_snail_mail_templates, :name, :class_name => 'Marketing::SnailMail::Template'
    
  def new
    @template = current_user.marketing_snail_mail_templates.build
  end
  
  def create
    @template = current_user.marketing_snail_mail_templates.build(params[:marketing_snail_mail_template])
    respond_to do |format|
      if @template.save
        format.js {}
        format.html {
          flash[:notice] = "Successfully Created."
          redirect_to marketing_snail_mail_template_path( @template )
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
    @template = Marketing::SnailMail::Template.find(params[:id])
  end
  
  def update
    @template = Marketing::SnailMail::Template.find(params[:id])
    respond_to do |format|
      if @template.update_attributes(params[:marketing_snail_mail_template])
        format.js {}
        format.html { 
          flash[:notice] = "Successfully Updated."
          redirect_to marketing_snail_mail_template_path( @template )
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
    templates = current_user.marketing_snail_mail_templates
    @templates = templates.paginate(page: params[:page], per_page: 10,
                                              total_entries: templates.length)
  end
  
  def show
    @template = Marketing::SnailMail::Template.find(params[:id])
  end

  def destroy
    @template = Marketing::SnailMail::Template.find(params[:id])
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
    @results = Marketing::SnailMail::Template.template_body_dynamic_options.collect do |x| 
      x if x[:value].to_s.include? params[:term]
    end
    respond_to do |format|
        format.json { render :json => @results.compact.to_json }
    end
  end

  def get_autocomplete_items(parameters)
    items = super(parameters)
    items = items.where(:owner_id => current_user.id)
  end
end
