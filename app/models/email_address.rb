class EmailAddress < ActiveRecord::Base
  attr_accessible :contact_info_id, :value

  validates :value, :email => true , :if =>  :value_present?
  belongs_to :contact_info, class_name: "ContactInfo"

  def value_present?
    !self.value.blank?
  end
end
