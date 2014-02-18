require 'spec_helper'
require 'support/feature_helpers.rb'
include RequestsHelper
require 'database_cleaner'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe "Crm Notes CRUD" do
  before(:each) do
    Usage::User.delete_all
    Crm::Connection.delete_all
    Crm::Case.delete_all
    Crm::Note.delete_all
    @user = FactoryGirl.create(:usage_user)
    @connection = FactoryGirl.create(:crm_connection, :agent_id => @user.id, :connection_type_id => 3)
    @case = FactoryGirl.create(:crm_case, :connection_id => @connection.id)
    ownership = FactoryGirl.create(:ownership_global)
    status_type = FactoryGirl.create(:crm_status_type, :ownership_id => ownership.id)
    request_login(@user)
  end

  it "should create note for a case successfullt" do
    create_new_note
    @new_note = Crm::Note.last
    assert page.has_text?(@user.full_name)
    assert page.has_text?(@new_note.created_at)
    assert page.has_text?(@new_note.title)
    click_on @new_note.user.full_name
    assert page.has_text?(@new_note.text)
  end

  it "should edit note successfully" do
    create_new_note
    @new_note = Crm::Note.last
    assert page.has_text?(@user.full_name)
    assert page.has_text?(@new_note.created_at)
    assert page.has_text?(@new_note.title)
    fill_and_submit_notes_form( "#edit-note-"+"#{@new_note.id}", "#edit-note-modal-form-submit",'edit')
    @updated_note = Crm::Note.last
    @new_note.title.should_not eq(@updated_note.title)
    assert page.has_text?(@updated_note.title)
    assert page.has_text?('Note Successfully Updated')
  end

  it "should delete note successfully" do
    create_new_note
    @new_note = Crm::Note.last
    sleep 2
    find("#delete-note-"+"#{@new_note.id}").click
    assert page.has_no_text?(@user.full_name)
    assert page.has_no_text?(@new_note.created_at)
    assert page.has_no_text?(@new_note.title)
  end

  def create_new_note
    click_on 'Client Management'
    click_on @connection.first_name.capitalize
    click_on 'Notes'
    sleep 2
    fill_and_submit_notes_form("#new-note-modal-pop-up", "#new-note-modal-form-submit")
  end

  def fill_and_submit_notes_form(button_type, submit_button, dynamic_text = nil)
    find(button_type).click
    fill_in 'crm_note[title]', :with => "Test Note #{dynamic_text}"
    fill_in 'crm_note[text]', :with => "Note text #{dynamic_text}"
    find(submit_button).click
    assert page.has_text?('Note Successfully Created')
  end

end
