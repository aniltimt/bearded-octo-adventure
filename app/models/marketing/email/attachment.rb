class Marketing::Email::Attachment < ActiveRecord::Base
  attr_accessible :file, :message_id

  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  # Associations
  belongs_to :message, :foreign_key => :message_id,:class_name => "Marketing::Email::Message"

end
