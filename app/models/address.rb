class Address < ActiveRecord::Base
  attr_accessible :contact_info_id, :value
  belongs_to :contact_info, class_name: "ContactInfo"
end
