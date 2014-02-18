class Usage::CommissionLevel < CluEnum
  self.table_name = 'usage_commission_levels'
  self.primary_key = :id
  attr_accessible :name

  # Associations
  has_many :users, class_name: "Usage::User", :foreign_key => "commission_level_id"

end
