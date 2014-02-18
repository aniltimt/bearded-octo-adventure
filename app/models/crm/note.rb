class Crm::Note < ActiveRecord::Base
  include Crm::BelongsToCaseStereotype
  attr_accessible :confidential, :user_id, :note_type_id, :text, :title, :case_id,
  :connection_id, :connection, :user, :case

  belongs_to :case, class_name: "Crm::Case"
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
  belongs_to :user, class_name: "Usage::User"
  belongs_to :note_type, class_name: "Crm::NoteType"

  scope :get_notes_except_note_type_exam, lambda { |connection, user|
    joins(:note_type).
    where("crm_notes.connection_id = ? AND crm_note_types.name <> ? AND
      crm_notes.confidential = ? AND crm_notes.user_id = ?",
      connection.id, "exam", false, user.id)
  }


end
