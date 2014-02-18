require "spec_helper"

describe Crm::NotesController do
  describe "#index" do
    let(:crm_connection) { fire_double("Crm::Connection") }
    let(:user) { fire_double("Usage::User") }
    let(:params) { {id: 42} }
    let(:crm_notes) { [] }

    before do
      controller.stub(:current_user).and_return(user)
      Crm::Note.stub(:get_notes_except_note_type_exam).with(crm_connection, user).and_return(crm_notes)
      Crm::Connection.stub(:find_by_id).with("42").and_return(crm_connection)
      crm_connection.stub(:viewable?).with(user).and_return(true)
    end

    it "assigns crm_notes" do
      xhr :get, "index", params
      assigns[:crm_notes].should == crm_notes
    end

    it "returns http success" do
      xhr :get, "index", params
      response.should be_success
    end
  end
end
