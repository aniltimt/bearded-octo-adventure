class Reporting::SearchCondition < ActiveRecord::Base
  attr_accessible :current, :date_max, :date_min, :search_field_id,
                  :search_condition_set_id, :text
                  
  # Associations
  belongs_to :search_condition_set
  belongs_to :search_field
end
