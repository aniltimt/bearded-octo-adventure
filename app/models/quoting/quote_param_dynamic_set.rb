class Quoting::QuoteParamDynamicSet < ActiveRecord::Base
  attr_accessible :category_id, :connection_id, :face_amount, :premium_mode_id

  # Associations
  belongs_to :crm_connection, :class_name => "Crm::Connection", :foreign_key => :connection_id
  belongs_to :category, :foreign_key => :category_id, :class_name => "TliCategoryOption"
  belongs_to :premium_mode, :foreign_key => :premium_mode_id, :class_name => "PremiumModeOption"

end
