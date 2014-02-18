class Tagging::TagKey < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :owner_id, :owner, :ownership, :ownership_id

  validates :name, uniqueness:true

  # Associations
  has_and_belongs_to_many :saved_searches
  has_many :tag_assignment_rules
  has_many :tags, class_name: "Tagging::Tag"
  has_many :tag_values, :through => :tags
  belongs_to :auto_tag_rule_set, :class_name => "Tagging::AutoTagRuleSet"
  belongs_to :owner, class_name: "Usage::User"
  belongs_to :ownership
  belongs_to :user, class_name: "Usage::User"
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id

  def get_commom_tags_for_user(user_id)
     user = Usage::User.find(params[:user_id])
     tags = user.tags
  end

  def self.search(search)
    if search
      where('name like ?', "%#{search}%")
    end
  end
end
