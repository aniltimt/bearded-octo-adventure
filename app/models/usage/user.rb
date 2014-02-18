class Usage::User < ActiveRecord::Base

  GENDER = { false => 'Female', true => "Male" }
  acts_as_authentic

  include PersonStereotype
  include TaggableStereotype
  include Usage::UserRoleMethods

  PRIVILAGE_SIBLINGS = {'none' => {'can_view_siblings'=>false, 'can_edit_siblings' => false},
    'can_view_siblings' => {'can_view_siblings'=>true, 'can_edit_siblings' => false},
    'can_edit_siblings' => {'can_view_siblings'=>true, 'can_edit_siblings' => true}
  }

  PRIVILAGE_NEPHEWS = {'none' => {'can_view_nephews'=>false, 'can_edit_nephews' => false},
    'can_view_nephews' => {'can_view_nephews'=>true, 'can_edit_nephews' => false},
    'can_edit_nephews' => {'can_view_nephews'=>true, 'can_edit_nephews' => true}
  }

  PRIVILAGE_DESCENDENTS = {'none' => {'can_view_descendents'=>false, 'can_edit_descendents' => false},
    'can_view_descendents' => {'can_view_descendents'=>true, 'can_edit_descendents' => false},
    'can_edit_descendents' => {'can_view_descendents'=>true, 'can_edit_descendents' => true}
  }

  PRIVILAGE_SIBLINGS_RESOURCES = {'none' => {'can_view_siblings_resources'=>false, 'can_edit_siblings_resources' => false},
    'can_view_siblings_resources' => {'can_view_siblings_resources'=>true, 'can_edit_siblings_resources' => false},
    'can_edit_siblings_resources' => {'can_view_siblings_resources'=>true, 'can_edit_siblings_resources' => true}
  }

  PRIVILAGE_NEPHEWS_RESOURCES = {'none' => {'can_view_nephews_resources'=>false, 'can_edit_nephews_resources' => false},
    'can_view_nephews_resources' => {'can_view_nephews_resources'=>true, 'can_edit_nephews_resources' => false},
    'can_edit_nephews_resources' => {'can_view_nephews_resources'=>true, 'can_edit_nephews_resources' => true}
  }

  PRIVILAGE_DESCENDENTS_RESOURCES = {'none' => {'can_view_descendents_resources'=>false, 'can_edit_descendents_resources' => false},
    'can_view_descendents_resources' => {'can_view_descendents_resources'=>true, 'can_edit_descendents_resources' => false},
    'can_edit_descendents_resources' => {'can_view_descendents_resources'=>true, 'can_edit_descendents_resources' => true}
  }

  after_save :delayed_update_ascendent_associations

  attr_accessible :enabled, :login, :parent_id, :agent_field_set_id, :role_id,
                  :sales_support_field_set_id, :nickname, :note, :manager_id,
                  :commission_level_id, :password, :password_confirmation,
                  :contact_info_id, :selected_profile_id

  # Person
  attr_accessible :anniversary, :first_name, :last_name, :middle_name, :birth, :gender,
                  :title
  # Privileges
  attr_accessible :can_edit_crm_core, :can_edit_crm_status_meta, :can_edit_crm_tags,
                  :can_edit_profiles, :can_edit_self, :can_edit_siblings,
                  :can_have_children, :can_view_siblings, :can_view_siblings_resources,
                  :can_edit_siblings_resources, :can_view_descendents, :can_edit_descendents,
                  :can_view_descendents_resources, :can_edit_descendents_resources, :can_view_nephews,
                  :can_edit_nephews, :can_view_nephews_resources, :can_edit_nephews_resources

  # Accessible attrs for associations
  attr_accessible :agent_field_set, :agent_of_record,
                  :commission_level, :commission_level_attributes,
                  :contact_info, :contact_info_attributes,
                  :manager, :parent,
                  :sales_support_field_set, :sales_support_field_set_attributes,
                  :staff_assignment, :staff_assignment_attributes,
                  :role

  validates_uniqueness_of :login

  # Associations

  belongs_to :agent_field_set, class_name:'Usage::AgentFieldSet'
  belongs_to :agent_of_record, :class_name => "Usage::User"
  belongs_to :commission_level, :class_name => "Usage::CommissionLevel"
  belongs_to :contact_info
  belongs_to :manager, :class_name => "Usage::User"
  belongs_to :parent, :class_name => "Usage::User"
  belongs_to :sales_support_field_set
  belongs_to :selected_profile, :class_name => "Usage::Profile"
  belongs_to :staff_assignment, class_name:'Usage::StaffAssignment'
  belongs_to :role, :class_name => "Usage::Role"

  has_many :usage_notes, class_name: "Usage::Note", :foreign_key => :user_id
  has_many :messages, :foreign_key => :user_id, :class_name => "Marketing::Email::Message"
  has_many :snail_messages, :foreign_key => :user_id, :class_name => "Marketing::Email::Message"
  has_many :snail_mail_messages, class_name: 'Marketing::SnailMail::Message', dependent: :destroy, foreign_key: :sender_id
  has_many :email_messages, class_name: 'Marketing::Email::Message', dependent: :destroy, foreign_key: :sender_id
  has_many :licenses, class_name:'Usage::License', through: :agent_field_set
  has_many :crm_connections, class_name: "Crm::Connection", :foreign_key => :agent_id
  has_many :contracts
  has_many :notes, class_name: "Crm::Note"
  has_many :activities, :foreign_key => :owner_id, class_name: "Crm::Activity"
  has_many :status_types, class_name: "Crm::StatusType"
  has_and_belongs_to_many :profiles, :foreign_key => :user_id, :class_name => "Usage::Profile", :join_table => 'usage_profiles_users'

  has_many :children, :foreign_key => :parent_id, :class_name => "Usage::User"
  has_many :marketing_email_templates, class_name: "Marketing::Email::Template",
           foreign_key: 'owner_id'
  has_many :marketing_snail_mail_templates, class_name: "Marketing::SnailMail::Template",
           foreign_key: 'owner_id'
  has_many :marketing_message_media_templates, class_name: "Marketing::MessageMedia::Template",
           foreign_key: 'owner_id'
  has_many :tags, :class_name => "Tagging::Tag"
  has_many :tag_keys, :class_name => "Tagging::TagKey", :through => :tags
  has_many :lead_distribution_weights, :foreign_key => :agent_id
  has_many :smtp_servers, :foreign_key => :owner_id, :class_name => "Marketing::Email::SmtpServer"
  has_one :marketing_membership, :foreign_key => :owner_id, class_name: "Marketing::Membership"

  has_and_belongs_to_many :ascendents,  :join_table => 'usage_ascendents_descendents', :association_foreign_key => :ascendent_id, :foreign_key => :descendent_id, :class_name => "Usage::User"
  has_and_belongs_to_many :descendents, :join_table => 'usage_ascendents_descendents', :association_foreign_key => :descendent_id, :foreign_key => :ascendent_id, :class_name => "Usage::User"


  has_many :crm_system_tasks, class_name: "Crm::SystemTask", :foreign_key => :created_by

  accepts_nested_attributes_for :contact_info

  # Liquid methods
  liquid_methods :photo, :signature, :first_name, :last_name

  ### NAMED SCOPES ###

  # Scope Users who have an 'agent' Role
  scope :agents, lambda { where(:role_id => AppCache.agent_role_id) }

  # Scope Users who are children of group
  scope :children_of, lambda { |group_id| where(:parent_id => group_id) }

  # Scope Users who are not temporarily suspended
  scope :not_suspended, lambda {
    table = reflect_on_association(:agent_field_set).table_name
    joins(:agent_field_set)
    .where("#{table}.temporary_suspension IS NULL OR #{table}.temporary_suspension != 1")
  }

  # Scope Users who are active at their computer
  scope :available, lambda { where("last_request_at >= ?", 30.minutes.ago.round(0).to_s(:db)) }

  # Scope Users who have a high enough premium limit (for the given lead type)
  scope :for_premium_limit, lambda { |lead_type_id, premium|
    if premium.nil? or lead_type_id.nil?
      where(nil)
    else
      ldw_table = Usage::LeadDistributionWeight.table_name
      joins( :lead_distribution_weights )
      .where( "#{ldw_table}.tag_value_id = ?", lead_type_id )
      .where( "#{ldw_table}.premium_limit >= ?", premium )
    end
  }

  # Scope Users who are licensed in the Case's state
  scope :licensed, lambda { |state_id|
    joins( :agent_field_set => :licenses )
    .where( "#{Usage::License.table_name}.state_id = ?", state_id )
  }

  # Scope Users whose countdown is > 0
  scope :countdown_positive, lambda { |lead_type_id|
    joins( :lead_distribution_weights )
    .where( "tag_value_id = ?", lead_type_id )
    .where( "countdown > 0" )
  }

  scope :groups, lambda { where(role_id:Usage::Role.group_id) }

  # Scope Users whose Role is a sales support role
  scope :sales_support, lambda {
    joins(:role).
    where(" usage_roles.name in (?)", Usage::Role::SUPPORT_ROLES)
  }

  # Scope Users which are viewable for a given User
  scope :viewables, lambda { |user|
    if not (user.can_view_siblings? or user.can_view_descendents? or user.can_view_nephews?)
      return where(:id => user.id)
    end
    rel = joins('INNER JOIN `usage_ascendents_descendents` ON `usage_ascendents_descendents`.`descendent_id` = `usage_users`.`id`')
    if user.can_view_siblings? and user.can_view_descendents? and user.can_view_nephews?
      rel = rel.where('usage_ascendents_descendents.ascendent_id' => user.parent_id)
    else
      statement_string = []
      statement_params = []
      if user.can_view_descendents?
        statement_string << 'ascendent_id = ?'
        statement_params << user.id
      end
      if user.can_view_siblings?
        statement_string << 'parent_id = ?'
        statement_params << user.parent_id
      end
      if user.can_view_nephews?
        statement_string << 'ascendent_id in (?)'
        statement_params << siblings(user).select(:id).map(&:id)
      end
      rel = rel.where(statement_string.join(' OR '), *statement_params)
    end
    rel
  }

  # Scope Users which are editable for a given User
  scope :editables, lambda { |user|
    if not (user.can_edit_siblings? or user.can_edit_descendents? or user.can_edit_nephews?)
      return user.can_edit_self ? where(:id => user.id) : where(0)
    end
    rel = joins('INNER JOIN `usage_ascendents_descendents` ON `usage_ascendents_descendents`.`descendent_id` = `usage_users`.`id`')
    if user.can_edit_siblings? and user.can_edit_descendents? and user.can_edit_nephews?
      rel = rel.where('usage_ascendents_descendents.ascendent_id' => user.parent_id)
    else
      statement_string = []
      statement_params = []
      if user.can_edit_descendents?
        statement_string << 'ascendent_id = ?'
        statement_params << user.id
      end
      if user.can_edit_siblings?
        statement_string << 'parent_id = ?'
        statement_params << user.parent_id
      end
      if user.can_edit_nephews?
        statement_string << 'ascendent_id in (?)'
        statement_params << siblings(user).select(:id).map(&:id)
      end
      rel = rel.where(statement_string.join(' OR '), *statement_params)
    end
    rel
  }

  def ascendent_ids
    self.ascendents.map(&:id)
  end

  def can_edit_user?(arg)
    arg_user = arg.kind_of?(Usage::User) ? arg : Usage::User.find_by_id(arg)

    return true if self.role.try(:super?)
    return false if arg_user.blank?
    if self.can_edit_self === true && self.id === arg_user.id
      return true
    end
    if self.can_edit_siblings === true && self.parent_id === arg_user.parent_id
      return true
    end
    return true if arg_user.ascendent_ids.include?(self.id)
    false
  end

  def can_view_user?(arg)
    arg_user = arg.kind_of?(Usage::User) ? arg : Usage::User.find_by_id(arg)

    return true if self.id === arg_user.id || self.role.try(:super?)
    return false if arg_user.blank?
    return true if arg_user.ascendent_ids.include?(self.id)
    if (self.can_view_siblings === true || self.can_edit_siblings === true ) && self.parent_id === arg_user.parent_id
      return true
    end
    false
  end

#  def can_have_children?
#    can_view_descendents?
#  end

  def can_view_descendents?
    can_view_descendents || can_edit_descendents
  end

  def can_view_siblings?
    can_view_siblings || can_edit_siblings
  end

  def can_view_nephews?
    can_view_nephews || can_edit_nephews
  end

  def can_view_descendents_resources?
    can_view_descendents_resources || can_edit_descendents_resources
  end

  def can_view_siblings_resources?
    can_view_siblings_resources || can_edit_siblings_resources
  end

  def can_view_nephews_resources?
    can_view_nephews_resources || can_edit_nephews_resources
  end

  def current_profile cookies
    id = current_profile_id cookies
    id.nil? ? self.profiles.first : Profile.find(id)
  end

  def current_profile_id cookies
    cookies[:profile_id].blank? ? nil : cookies[:profile_id]
  end

  # Returns true if this user is a descendent of arg user
  def descendent? user
    reflection = Usage::User.reflect_on_association :descendents
    table = Arel::Table.new(reflection.options[:join_table])
    query = table \
      .where( table[reflection.foreign_key].eq(user.id) ) \
      .where( table[reflection.association_foreign_key].eq(self.id) ) \
      .project('*').take(1).to_sql
    results = self.connection.execute query
    results.first.present?
  end

  def descendent_ids
    self.descendents.map(&:id)
  end

  def editable_connections
    ids = self.descendent_ids
    ids << self.id
    Crm::Connection.where(:agent_id=>ids)
  end

  def has_docusign_credentials?
    self.agent_field_set.present?
  end

  def group
    user = self
    # find the first user/ancestor whose role is group
    while user
      if user.role.try(:name) == 'group'
        return user
      end
      user = user.parent
    end
    return nil
  end

  def group?
    self.role.try(:name) == 'group'
  end

  def working_hours?
    #need to implement
  end

  def send_password_reset(email)
    reset_perishable_token!
    #Notifier.deliver_password_reset_instructions(self)
    UserMailer.password_reset(self, email).deliver
  end

  def full_name
    "#{self.first_name} "+"#{self.last_name}"
  end

  def self.find_ancestry_between_users(ancestor_user, user)
    users = [user]
    users << ancestor = user.parent if user.parent
    while ( ancestor && ancestor.id != ancestor_user.id ) do
      users << ancestor = ancestor.parent
    end
    users
  end

  def get_current_smtp_setting
    unless self.smtp_servers.blank?
      smtp_server = self.smtp_servers.first
      {
        :address => smtp_server.address,
        :port => smtp_server.port,
        :user_name => smtp_server.username,
        :password => smtp_server.decrypt_password,
        :ssl => smtp_server.ssl
      }
    else
      ActionMailer::Base.smtp_settings
    end
  end

  # Return array of state_ids for which this users is licensed
  def licensed_state_ids
    agent_field_set.present? ? agent_field_set.licenses.map{|l| l.state_id} : []
  end

  def sales_support(role)
    if role.class == Fixnum
      role_id = role
    elsif role.class == String
      role_id = Usage::Role.find_by_name(role).try(:id)
    else
      role_id = role.id
    end

    # find the siblings excluding the self
    users = Usage::User.where("parent_id = ? AND role_id = ? AND id <> ?", self.parent_id, role_id, self.id)

    if users.present?
      return users.first
    else
      parent = self.parent
    # find the first ancestor whose role_id = role_id
      while parent
        if parent.role_id == role_id
          return parent
        end
        parent = parent.parent
      end
    end
    return nil
  end

  # Make delayed job for updating ascendent associations (This is an after_save callback)
  def delayed_update_ascendent_associations force=false
    if self.parent_id_changed? or force
      self.delay._update_ascendent_associations
    end
  end

  def system_task_email_agent
    self.crm_system_tasks.joins(:task_type, :status).includes(:status).where('crm_system_task_types.name=? AND crm_system_tasks.completed_at IS ? AND crm_system_tasks.due_at < ?', 'email agent', nil, Time.now).each do |system_task|
      if system_task.status.case.active
        unless system_task.marketing_email_template.blank?
          system_task.send_email
        end
      end
    end
  end

  def system_task_email
    self.crm_system_tasks.joins(:task_type, :status).includes(:status).where('crm_system_task_types.name=? AND crm_system_tasks.completed_at IS ? AND crm_system_tasks.due_at < ?', 'email', nil, Time.now ).each do |system_task|
      if system_task.status.case.active
        unless system_task.marketing_email_template.blank?
          system_task.send_email
        end
      end
    end
  end

  # Returns id. The purpose is so that functions that accept a User or id
  # can quickly get the id without any logic.
  def to_i
    self.id
  end

  # Delete all ascendent associations and recreate them
  def _update_ascendent_associations
    self.reload
    if parent.present?
      self.ascendents = parent.ascendents.where('id != ?', id).select(:id) << parent
      # instruct children to update their ascendent associations as well
      self.children.each{|child|
        # protect against loops in ascendency
        break if child == self
        child._update_ascendent_associations
      }
    end
  end

  # lead_type_id and annual_premium may be nil
  def self.agent_for_assignment group_id, state_id, lead_type_id, annual_premium
    # Scope required attributes for elligible agents:
    # => role of 'agent'
    # => licensed in state
    # => children of given group
    relation = self.
      children_of(group_id).
      agents.
      licensed(state_id).
      includes(:agent_field_set)
    if lead_type_id.present?
      weights_table_name = reflect_on_association(:lead_distribution_weights).table_name
      relation = relation.
        includes(:lead_distribution_weights).
        where("#{weights_table_name}.tag_value_id = ?", lead_type_id)
    end
    candidates = relation.all
    # sort candidates by their countdown on the lead_distribution_weight for the given lead_type
    if lead_type_id.present?
      candidates.sort!{|a,b|
        weight_a = a.lead_distribution_weights.select{|w| w.tag_value_id == lead_type_id}.first
        weight_b = b.lead_distribution_weights.select{|w| w.tag_value_id == lead_type_id}.first
        if weight_a.nil? and weight_b.nil?
          0
        elsif weight_a.nil?
          1
        elsif weight_b.nil?
          -1
        else # largest countdown appears first
          weight_b.countdown <=> weight_a.countdown
        end
      }
    end
    # make a duplicate pointer for condidates variable
    selection = candidates
    # Scope desired attributes for elligible agents:
    # => premium limit
    # => available (not AFK - away from keyboard)
    # => not suspended
    # => awaiting a lead (countdown positive)
    # try to get a candidate whose premium limit exceeds annual_premium
    if lead_type_id.present? and annual_premium.present?
      selection = candidates.select{|c|
        weight = c.lead_distribution_weights.select{|w| w.tag_value_id == lead_type_id}.first
        weight and weight.premium_limit >= annual_premium.to_f
      }
      return candidates.first if selection.empty?
    end
    # try to get a candidate who is available
    candidates = selection
    selection = candidates.select{|c| c.last_request_at and c.last_request_at >= 30.minutes.ago }
    return candidates.first if selection.empty?
    # try to get a candidate who is not suspended
    candidates = selection
    selection = candidates.select{|c| c.agent_field_set.try(:temporary_suspension) != true}
    return candidates.first if selection.empty?
    # return first user (sorted by countdown for given lead type) from selection
    candidates = selection
    return candidates.first
  end

  def self.licensed_state_ids users=[], options={}
    arr = users.map{|u| u.licensed_state_ids}.flatten
    arr.uniq! unless options[:unique] == false
    arr.sort! unless options[:sort] ==  false
  end

  def self.licensed_state_ids users=[], options={}
    arr = users.map{|u| u.licensed_state_ids}.flatten
    arr.uniq! unless options[:unique] == false
    arr.sort! unless options[:sort] ==  false
  end

  def self.licensed_state_ids users=[], options={}
    arr = users.map{|u| u.licensed_state_ids}.flatten
    arr.uniq! unless options[:unique] == false
    arr.sort! unless options[:sort] ==  false
  end

  #Explicit column definitions for rspec-fire
  def first_name; super; end
  def last_name; super; end
end
