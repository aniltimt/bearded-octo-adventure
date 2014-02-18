class Tagging::TagType < CluEnum
  self.table_name = 'tagging_tag_types'
  self.primary_key = :id
  attr_accessible :name

  has_many :tags, class_name: "Tagging::Tag"
end
