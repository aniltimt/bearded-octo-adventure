module Crm::HasActivityStereotype

  def find_or_create_activity
    Crm::Activity.where(:foreign_key => self.id,
          :activity_type_id => self.class::ACTIVITY_TYPE).first_or_create
  end
end
