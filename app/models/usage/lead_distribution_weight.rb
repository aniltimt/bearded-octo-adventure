class Usage::LeadDistributionWeight < ActiveRecord::Base
  attr_accessible :agent_id, :tag_value_id, :weight, :premium_limit, :countdown, :lock_version,
                  :tag_value
  
  # Associations
  belongs_to :agent, :foreign_key => :agent_id, :class_name => "Usage::User"

  belongs_to :tag_value, :foreign_key => :tag_value_id, :class_name=> "Tagging::TagValue"

  attr_accessor :attempts_to_crement_countdown
  
  def decrement_countdown!
    self.countdown = self.countdown - 1
    save
  rescue ActiveRecord::StaleObjectError
    attempts_to_crement_countdown ||= 0
    attempts_to_crement_countdown += 1
    unless attempts_to_crement_countdown > 5
      self.decrement_countdown!
    else
      false
    end
  ensure
    # increment siblings' countdowns for this lead type if countdown has reached (or passed) 0
    if self.countdown < 1
      self.class.increment_countdowns(agent.parent_id, tag_value_id)
    end
  end
  
  def increment_countdown!
    self.countdown = self.countdown + self.weight
    save
  rescue ActiveRecord::StaleObjectError
    attempts_to_crement_countdown ||= 0
    attempts_to_crement_countdown += 1
    unless attempts_to_crement_countdown > 5
      self.increment_countdown! 
    else
      false
    end
  end

  def self.increment_countdowns parent_id, lead_type_id
    if lead_type_id.present?
      joins(:agent)
      .where("#{reflect_on_association(:agent).table_name}.parent_id = ?", parent_id)
      .where(tag_value_id:lead_type_id)
      .all(readonly:false).each { |weight|
        weight.increment_countdown!
      }
    end
  end

end
