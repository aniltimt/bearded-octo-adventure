class Website < ActiveRecord::Base
  attr_accessible :contact_info_id, :url
  belongs_to :contact_info, class_name: "ContactInfo"
end
