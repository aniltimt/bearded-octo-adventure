class Marketing::Campaign < ActiveRecord::Base
  attr_accessible :owner_id, :ownership_id, :name
  
  # Association
  has_many :auto_task_rules
  has_many :tasks
  belongs_to :owner, :foreign_key => :owner_id, :class_name => Usage::User
end
