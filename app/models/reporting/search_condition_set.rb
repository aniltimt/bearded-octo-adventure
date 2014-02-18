class Reporting::SearchConditionSet < ActiveRecord::Base
  attr_accessible :name, :search_id

  # Associations
  belongs_to :search
  has_many :search_conditions
end
