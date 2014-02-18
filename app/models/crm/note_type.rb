class Crm::NoteType < CluEnum
  self.table_name = 'crm_note_types'
  self.primary_key = :id
  # attr_accessible :title, :body
  has_many :notes, class_name: "Crm::Note"
end
