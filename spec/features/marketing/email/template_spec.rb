require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end


describe "Marketing Email Templates" do
  before(:each) do
    Usage::User.delete_all
    Marketing::Membership.delete_all
    Crm::Connection.delete_all
	Marketing::Email::Template.delete_all
    @user = FactoryGirl.create(:usage_user)
    @crm_connection = FactoryGirl.create(:crm_connection_w_assoc, :agent_id => @user.id)
    @membership = FactoryGirl.create(:marketing_membership, :owner_id => @user.id)
    request_login(@user)
  end
  
   it "should create marketing template" do
    count = Marketing::Email::Template.count
    create_new_marketing_template
    click_on 'Submit'
    sleep 5
    Marketing::Email::Template.count.should eq(count+1)
  end
  
  it 'should not save if template name is blank' do
	count = Marketing::Email::Template.count
	sleep 2
	create_new_marketing_template_without_name
	click_on 'Submit'
	sleep 5
	Marketing::Email::Template.count.should eq(count)
  end
  
  it 'should edit existing marketing template' do
	create_marketing_template(1)
	@new_template = Marketing::Email::Template.last
	sleep 2
	count = Marketing::Email::Template.count
	edit_marketing_template
	click_on 'Submit'
	sleep 5
	assert page.has_text?('Successfully Updated.')
	@updated_template = Marketing::Email::Template.last
	@new_template.name.should_not eq(@updated_template.name)
	Marketing::Email::Template.count.should eq(count)
  end
  
  it 'should not edit existing marketing template if template name is blank' do
	create_marketing_template(1)
	sleep 2
	count = Marketing::Email::Template.count
	edit_marketing_template_without_name
	click_on 'Submit'
	sleep 5
	assert page.has_text?('Not Updated.')
	Marketing::Email::Template.count.should eq(count)
  end
  
  it 'should clone marketing template' do
	create_marketing_template(1)
	sleep 2
	count = Marketing::Email::Template.count
	go_and_search_marketing_template
	click_on 'Clone Template'
	sleep 5
	assert page.has_text?('Successfully Created')
	Marketing::Email::Template.count.should eq(count+1)
  end
  
  it 'should delete marketing template' do
	create_marketing_template(1)
	sleep 2
	count = Marketing::Email::Template.where(:enabled => true).count
	go_and_search_marketing_template
	find("#delete-template-#{@template.id}").click
	sleep 2
    page.driver.browser.switch_to.alert.accept
	assert page.has_text?('Successfully Deleted')
	Marketing::Email::Template.where(:enabled => true).count.should eq(count-1)
  end
  
  def create_new_marketing_template
	go_to_marketing_email_template
	click_on 'Create New Template'
	sleep 1
	fill_marketing_template_form
  end
  
  def create_new_marketing_template_without_name
	go_to_marketing_email_template
	click_on 'Create New Template'
	sleep 1
	fill_marketing_template_form_without_name
  end
  
  def edit_marketing_template
	go_and_search_marketing_template
	fill_marketing_template_form('edit')
  end

  def edit_marketing_template_without_name
	go_and_search_marketing_template
	fill_marketing_template_form_without_name
  end
  
  def go_to_marketing_email_template
	click_on 'Marketing'
	click_on 'Email Templates'
  end
  
  def create_marketing_template(count=1)
	count.times do |i|
	  FactoryGirl.create(:marketing_email_template, owner_id: @user.id, :enabled => true)
	end
  end
  
  def search_marketing_email_template
	@template = Marketing::Email::Template.last
	fill_autocomplete "edit-marketing-email-template", with: "#{@template.name}", select: "#{@template.name}"
	sleep 2
  end
  
  def fill_marketing_template_form(name_text=nil)
	fill_in 'marketing_email_template[name]', :with => Forgery(:name).full_name+" #{name_text}"
	fill_in 'marketing_email_template[description]', :with => Forgery(:basic).text
	find_by_id('marketing_email_template_enabled').set(true)
	find_by_id('marketing_email_template_ownership_id').find("option[value='1']").click
	fill_in 'marketing_email_template[subject]', :with => Forgery(:basic).text
	page.execute_script('$("#marketing_email_template_body").tinymce().setContent("This is the template body.")')
  end
  
  def fill_marketing_template_form_without_name
	fill_in 'marketing_email_template[name]', :with => nil
	fill_in 'marketing_email_template[description]', :with => Forgery(:basic).text
	find_by_id('marketing_email_template_enabled').set(true)
	find_by_id('marketing_email_template_ownership_id').find("option[value='1']").click
	fill_in 'marketing_email_template[subject]', :with => Forgery(:basic).text
	page.execute_script('$("#marketing_email_template_body").tinymce().setContent("This is the template body.")')
  end
  
  def fill_autocomplete(field, options = {})
    fill_in field, :with => options[:with]
    page.execute_script %Q{ $('##{field}').trigger("focus") }
    page.execute_script %Q{ $('##{field}').trigger("keydown") }
    selector = "ul.ui-autocomplete a:contains('#{options[:select]}')"
    page.should have_selector selector
    page.execute_script "$(\"#{selector}\").mouseenter().click()"
  end
  
  def go_and_search_marketing_template
	go_to_marketing_email_template
	search_marketing_email_template
  end
  
end
