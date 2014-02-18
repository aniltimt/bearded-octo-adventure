
# This class is used to generate search paramaters for offers

class SearchConditions
  def initialize()
    @wheres = []
    @values = []
  end              
  
  # Parse Key Value pairs and add them to the array
  def parse_param_string(params)
    # overriden in subclass
  end
  
  # Add where/value clauses to the array
  def add(where, value = nil)    
    @wheres << where
    if value.instance_of?(Array)
      value.collect {|v| @values << v }
    else
      @values << value unless value.nil?
    end
  end       
  
  # Return an array of values
  def conditions      
    unless @wheres.nil? or @values.nil?
      [@wheres.join(" AND ")] + @values
    else
      []
    end
  end 
  
  def joins
    ["inner join crm_cases on crm_cases.connection_id = crm_connections.id inner join contact_infos on contact_infos.id=crm_connections.contact_info_id inner join email_addresses on email_addresses.contact_info_id=contact_infos.id inner join addresses on addresses.contact_info_id=contact_infos.id inner join phones on phones.contact_info_id=contact_infos.id inner join quoting_results on quoting_results.id=crm_cases.approved_details_id or quoting_results.id=crm_cases.quoted_details_id or quoting_results.id=crm_cases.submitted_details_id inner join carriers on carriers.id=quoting_results.carrier_id inner join crm_policy_types on crm_policy_types.id=quoting_results.policy_type_id inner join states on states.id=contact_infos.state_id inner join crm_statuses on crm_statuses.id=crm_cases.status_id"]
  end              	
end