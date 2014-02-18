class Usage::AscendentAssociation < ActiveRecord::Base
  self.table_name = 'usage_ascendents_descendents'
  belongs_to :ascendent, class_name: 'Usage::User'
  belongs_to :descendent, class_name: 'Usage::User'
end