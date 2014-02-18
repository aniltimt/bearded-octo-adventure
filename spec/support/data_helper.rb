module DataHelper
  MAX_PREMIUM   = 5
  MAX_WEIGHT    = 5
  MAX_COUNTDOWN = 5

  def populate_agents_et_al
    # add Users
    Usage::Role.select(:id).each do |r|
      FactoryGirl.create_list( :usage_user, 7, role_id:r.id )
    end
    # add parents
    Usage::User.all.each do |u|
      parent_id = u.id % 5
      u.update_attributes(parent_id:parent_id) if parent_id > 0 and parent_id != u.id
    end
    # make some parents into groups
    Usage::User.where(id:[1,2,3]).each{|user| user.update_attributes(role_id:Usage::Role.group_id) }
    create_support_for_agents
  end

  def create_support_for_agents agents=nil, options={}
    # set defaults
    agents = Usage::User.where(role_id:Usage::Role.agent_id) if agents.nil?
    options[:premium_limit] ||= lambda{rand(MAX_PREMIUM)}
    options[:weight] ||= lambda{rand(MAX_WEIGHT)}
    options[:countdown] ||= lambda{rand(MAX_COUNTDOWN)}
    options[:last_request_at] ||= rand(80).minutes.ago
    def options.[](key)
      val = self.fetch(key)
      val = val.call if val.is_a?(Proc)
      val
    end
    # add lead types and LeadDistributionWeights
    Tagging::TagKey.find_or_create_by_name('lead type')
    @lead_types = []
    lead_types = %w[foo bar baz qux pop buzz]
    lead_types.each do |lead_type|
      tag_value = Tagging::TagValue.find_or_create_by_value(lead_type)
      @lead_types << tag_value
      agents.each do |agent|
        new_weight = Usage::LeadDistributionWeight.create(
          agent_id:agent.id,
          tag_value_id:tag_value.id,
          premium_limit:options[:premium_limit],
          countdown:options[:countdown],
          weight:options[:weight]
         )
        agent.lead_distribution_weights << new_weight
      end
    end
    # iterate through agents
    agents.each_with_index do |agent, i|
      # add agent field set
      agent.create_agent_field_set unless agent.agent_field_set.present?
      # add premium limit
      agent.agent_field_set.update_attributes premium_limit:options[:premium_limit]
      # add Licenses
      state_count = State.count
      license_count = (state_count / agents.length * 1.25).ceil
      license_count = 5 if license_count == 0
      first_license = license_count * i
      last_license = license_count + first_license
      (first_license...last_license).each do |idx|
        return if idx > state_count
        state_id = (idx % state_count) + 1
        new_license = Usage::License.create agent_field_set_id:agent.agent_field_set_id, number:'qwerty', state_id:state_id
        agent.agent_field_set.licenses << new_license
      end
      # set last activity
      agent.last_request_at = options[:last_request_at]
      agent.save
    end
  end
end