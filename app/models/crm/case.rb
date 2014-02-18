class Crm::Case < ActiveRecord::Base
  include Crm::Accessible

  # Associations
  belongs_to :agent, class_name: "Usage::User"
  belongs_to :approved_details, class_name: "Quoting::Quote"
  belongs_to :crm_connection, class_name: 'Crm::Connection', :foreign_key => :connection_id
  belongs_to :owner, class_name: "Crm::Owner"
  belongs_to :premium_payer, class_name: "Crm::Owner"
  belongs_to :quoted_details, class_name: "Quoting::Quote"
  belongs_to :staff_assignment, class_name: "Usage::StaffAssignment"
  belongs_to :status, class_name: "Crm::Status"
  belongs_to :submitted_details, class_name: "Quoting::Quote"

  has_many :notes, class_name: "Crm::Note"
  has_many :statuses, class_name: "Crm::Status", :foreign_key => :case_id
  has_many :beneficiaries, class_name: "Crm::Beneficiary"

  accepts_nested_attributes_for :quoted_details, :submitted_details, :approved_details,
      :beneficiaries, :crm_connection, :notes, :owner, :premium_payer

  attr_accessible :agent_id, :approved_details_id, :approved_premium_due,
                  :blind, :client_id, :cross_sell, :current_insurance_amount, :effective_date,
                  :equal_share_contingent_bens, :equal_share_primary_bens, :esign,
                  :exam_company, :active, :exam_num, :exam_status, :exam_time,
                  :insurance_exists, :ipo, :owner_id, :policy_number, :policy_period_expiration,
                  :quoted_details_id, :reason, :replaced_by_id, :status_id, :submitted_details_id,
                  :submitted_qualified, :underwriter_assist, :up_sell, :quoted_details, :connection,
                  :staff_assignment_id, :staff_assignment, :termination_date,
                  :insured_is_owner, :insured_is_premium_payer, :owner_is_premium_payer, :incl_1035,
                  :flat_extra, :flat_extra_years

  attr_accessible :quoted_details, :quoted_details_attributes,
                  :submitted_details, :submitted_details_attributes,
                  :approved_details, :approved_details_attributes,
                  :crm_connection, :crm_connection_attributes,
                  :beneficiary, :beneficiary_attributes,
                  :connection, :connection_id,
                  :premium_payer, :premium_payer_attributes,
                  :owner, :owner_attributes,
                  :beneficiaries_attributes,
                  :notes_attributes, :notes


  # Liquid methods
  liquid_methods :app_sent_at, :exam_date, :exam_time_of_day

  # Callbacks for save/create/update
  before_save   :set_termination_date
  before_create :assign_to_agent!
  after_create  :set_initial_status, :be_replacement_for_others, :set_connection_type

  # Scope for join with connection and users
  scope :connection_join, lambda {
    joins("LEFT OUTER JOIN crm_connections ON crm_connections.id = crm_cases.connection_id").
    joins("INNER JOIN usage_users ON usage_users.id = crm_connections.agent_id OR usage_users.id = #{self.table_name}.agent_id").
    joins('LEFT JOIN `usage_ascendents_descendents` ON `usage_ascendents_descendents`.`descendent_id` = `usage_users`.`id`')
    }

  scope :get_cases_for_manager, lambda { |user|
    ids = user.descendent_ids
    ids << user.id
    joins(:crm_connection).
    where("crm_connections.agent_id in (?) AND crm_cases.active = ?", ids, true)}

  scope :get_cases_for_user, lambda { |user|
    joins(:crm_connection).
    where("crm_connections.agent_id = ? AND crm_cases.active = ?", user.id, true)}

  scope :get_cases_for_connection_type, lambda { |type|
    joins(:crm_connection => :connection_type).
    where("crm_connection_types.name = ?", type)}

  def agent_id
    self.read_attribute(:agent_id) || self.crm_connection.try(:agent_id)
  end

  def app_sent_at
    status.try(:create_at)
  end

  # Assigns case to crm_connection#agent. If crm_connection#agent.nil?,
  # Assigns case to given user_or_id. If user_or_id has a role of 'group',
  # auto-assigns case to an agent in the group.
  # Returns nil unless an auto-assignment is performed.
  def assign_to_agent(user_or_id=nil)
    if user_or_id.present?
      self.agent = user_or_id.is_a?(Fixnum) ? Usage::User.find(user_or_id) : user_or_id
    end
    # do not perform assignment if this case is now assigned to a non-group User
    return if self.agent.present? and not self.agent.group?
    # use crm_connection.agent_id if arg and self.agent_id are nil
    if self.agent.blank?
      self.agent = crm_connection.agent if crm_connection.try(:agent).present?
      # abort if there is still no user (or group) to use
      if self.agent.nil?
        SystemMailer.no_agent_assignment_email(self).deliver
        return
      end
      # perform auto-assignment if this is assigned to a group
      if self.agent.group?
        assignee = find_agent_for_assignment(self.agent)
        return if assignee.nil?
        self.agent = assignee
        # update crm_connection.agent (since it was either blank or a group)
        crm_connection.update_attributes(agent_id:self.agent.id)
        # return agent
        return self.agent
      end
    end
  end

  # Calls assign_to_agent, then decrements lead distribution weight count
  # Increments LeadDistributionWeight.countdown for given lead_type (if any).
  def assign_to_agent!(user_or_id=nil)
    # assign this to agent and save
    assignee = assign_to_agent(user_or_id)
    # decrement lead distribution weight counts
    decrement_lead_distributrion_weight_countdown if assignee.present?
  end

  # Finds other Cases belonging to self.crm_connection.
  # Sets itself to replaced_by on other Cases if their replaced_by_id is zero.
  def be_replacement_for_others
    unless self.connection_id.blank? or self.id.blank?
      cases_to_replace = self.class.where(replaced_by_id:0).where(connection_id:self.connection_id).all
      cases_to_replace.each{|kase| kase.update_attributes(replaced_by_id:self.id) }
    end
  end

  def copy_exam(cas)
    if self.crm_connection === cas.crm_connection
      ['exam_company', 'exam_num', 'exam_status', 'exam_time'].each do |field|
        self[field] = cas[field]
      end
    end
    self.save!
  end

  def contingent_beneficiaries db_only=false
    if db_only
      self.beneficiaries.where contingent:true
    else
      self.beneficiaries.select{|b| b.contingent }
    end
  end

  def exam_date
    exam_time.try(:to_date)
  end

  def exam_time_of_day
    exam_time.strftime('%l:%M %p').lstrip
  end

  def find_agent_for_assignment group_or_group_id
    group_id = group_or_group_id.is_a?(Fixnum) ? group_or_group_id : group_or_group_id.id
    state_id = crm_connection.contact_info.state_id
    lead_type_id = crm_connection.get_tag('lead type').try(:tag_value_id)
    annual_premium = self.quoted_details.try(:computed_annual_premium)
    user = Usage::User.agent_for_assignment(group_id, state_id, lead_type_id, annual_premium)
    return user if user.present?
    # Send notification of failure to assign case
    Rails.logger.warn "No agent assignment for case #{self.id.inspect}"
    SystemMailer.no_agent_assignment_email(self).deliver
    nil
  rescue => e
    Rails.logger.error e.inspect
    e.backtrace.each{|line| Rails.logger.error line }
    SystemMailer.error_email(e).deliver
    nil
  end

  def get_schedule_url(exam_company)
    if exam_company == 'SMM'
      Processing::Smm::schedule_url(self)
    else
      Processing::ExamOne::schedule_url(self)
    end
  end

  def primary_beneficiaries db_only=false
    if db_only
      self.beneficiaries.where 'contingent is not true'
    else
      self.beneficiaries.select{|b| b.contingent != true }
    end
  end

  def status_string
    if in_force?
      "<p style='color:green;'>In Force<p>".html_safe
    elsif submitted_details
      "<p style='color:orange;'>Submitted</p>".html_safe
    else
      "<p style='color:grey;'>Not Submitted</p>".html_safe
    end
  end

  def plan_name
    return "" if self.current_details.blank?
    return "" if self.current_details.category.blank?
    return self.current_details.category.name
  end

  # Returns the Quoting::Quote of highest priority -- or nil
  def current_details
    if approved_details
      approved_details
    elsif submitted_details
      submitted_details
    elsif quoted_details
      quoted_details
    else
      nil
    end
  end

  # Returns whether this policy is in force
  def in_force?
    if self.effective_date.nil?
      false
    elsif self.termination_date.nil?
      Date.today >= effective_date
    else
      Date.today >= effective_date and Date.today < termination_date
    end
  end

  def locked?
    #need to implement
  end

  def set_initial_status
    first_status_type = Crm::StatusType.first
    set_status(first_status_type) if first_status_type.present?
  end

  def set_status(status_type)
    status_type = Crm::StatusType.find_by_id(status_type) if status_type.class == Fixnum

    self.status = Crm::Status.find_or_initialize_by_status_type_id_and_case_id(status_type.id, self.id)

    if status.new_record?
      status.save
      status_type.auto_system_task_rules.each do |auto_system_task_rule|
        system_task = Crm::SystemTask.create(:status_id => status.id)
        if auto_system_task_rule.task_type_id.blank?
          assignment = auto_system_task_rule.user_assignment(status)
          if assignment.blank?
            if self.agent && self.agent.email
              UserMailer.task_has_no_assignment_notification(self.agent, system_task).deliver
            elsif self.crm_connection.agent && self.crm_connection.agent.email
              UserMailer.task_has_no_assignment_notification(self.crm_connection.agent, system_task).deliver
            end
          else
            system_task.update_attribute(:assigned_to_id, assignment.id)
          end
        end
        due_at = Date.today + auto_system_task_rule.delay.to_i
        system_task.update_attributes(:label => auto_system_task_rule.label,
        :template_id => auto_system_task_rule.template_id, :connection_id => self.crm_connection.try(:id),
        :due_at => due_at, :task_type_id => auto_system_task_rule.task_type_id)
      end
    end
    return self.update_attribute(:status_id, status.id) ? self.status : nil
  end

  # Calculate and set termination_date if effective_date or approved_details_id has changed
  def set_termination_date
    if effective_date and approved_details.try(:duration) and (effective_date_changed? or approved_details_id_changed?)
      self.termination_date = Date.new(
        effective_date.year + approved_details.duration,
        effective_date.month,
        effective_date.day )
    end
  end

  def valid_quoter?
    # validate associations
    validates_presence_of :crm_connection, :quoted_details
    errors[:crm_connection] = 'has errors' unless crm_connection.valid_quoter? if crm_connection
    errors[:quoted_details] = 'has errors' unless quoted_details.valid_quoter? if quoted_details
    errors.empty?
  end

  def self.build_from_result(result)
    crm_case = Crm::Case.new
    crm_case.quoted_details = result
    crm_case.crm_connection = result.crm_connection
    crm_case.assign_to_agent(nil)
    crm_case.save!
  end

  def wholesale_app?
    if crm_connection.profile.nil?
      true
    else
      crm_connection.profile.name.match(/[eE][zZ]/).nil?
    end
  end

  def esign?
    esign
  end

  def take_out_packet?
    #TODO: How do we determine take out packet?
    false
  end

  #Explicit column definitions for rspec-fire
  def created_at; super; end

  private

    # decrements countdown on the LeadDistributionWeight for this Case's agent and crm_connection
    def decrement_lead_distributrion_weight_countdown
      lead_type_id = self.crm_connection.try(:lead_type_id)
      if lead_type_id.present?
        weight = self.agent.lead_distribution_weights.where(tag_value_id:lead_type_id)
        weight.decrement_countdown!
      end
    end

    def set_connection_type
      connection = self.crm_connection
      unless ["client", "lead"].include?(connection.try(:connection_type).try(:name))
        connection_type = Crm::ConnectionType.find_by_name("lead")
        connection.try :update_attribute, :connection_type_id, connection_type.try(:id)
      end
    end

  pseudo_date_accessor :termination_date, next:'years_until_termination_date'

  find_or_create_by_default :approved_details, :quoted_details, :submitted_details

end