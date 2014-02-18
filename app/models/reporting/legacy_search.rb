class Reporting::LegacySearch < ActiveRecord::Base
  include OwnedStereotype
  attr_accessible :ownership_id, :search_name, :first_name, :middle_name, :last_name, :city, :state_id, :zip, 
                  :phone, :email, :age_from, :age_to, :campaign_id, :source, :i_c, :sales_support_id, :agent_name, 
                  :carrier_name, :lead_type, :profile_id, :policy_type_id, :face_amount_from, :face_amount_to,
                  :annual_premium_from, :annual_premium_to, :app_status, :status_category_id, :status_id, :owner_id
                  
  # Associations
  belongs_to :ownership, :class_name => "Ownership"
  belongs_to :owner, :class_name => "Usage::User"
end
