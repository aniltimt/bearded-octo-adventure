module LiquidFieldOptions

  def template_body_dynamic_options
    items = [
     {:label =>  'days_from_now 0', :value => 'days_from_now 0'},
     {:label =>  'days_from_now 15', :value => 'days_from_now 15'},
     {:label =>  'days_from_now 30', :value => 'days_from_now 30'},
     {:label =>  'days_from_now 45', :value => 'days_from_now 45'},
     {:label =>  'days_from_now 60', :value => 'days_from_now 60'},
     {:label =>  'profile_name', :value => 'profile_name'},
     {:label =>  'connection_source_agency', :value =>  'connection_source_agency'},
     {:label =>  'connection | unsubscribe_href', :value =>  'connection | unsubscribe_href'},
     {:label =>  'case_current_details_face_amount | currency', :value =>  'case_current_details_face_amount | currency'}
    ]

    %w[app_sent_at exam_date exam_time_of_day product_type_name effective_date].each do |case_field|
      items << {:label => "case_#{case_field}", :value => "case_#{case_field}"}
    end

    %w[connection agent agent_of_record case_manager].each do |person|
      %w[first_name last_name title birth age anniversary].each do |field|
        items << {:label => "#{person}_#{field}", :value => "#{person}_#{field}"}
      end
    end
    
    %w[connection agent case_manager agent_of_record profile].each do |has_contact_info|
      %w[email phone zip fax address city state].each do |field|
        items << {:label => "#{has_contact_info}_#{field}", :value => "#{has_contact_info}_#{field}"} 
      end
    end

    %w[carrier_name policy_type.name].each do |current_details_field|
      items << {:label => "case_current_details_#{current_details_field}", :value => "case_current_details_#{current_details_field}"}
    end

    %w[quoted submitted approved].each do |app_status|
      %w[carrier_name planned_modal_preium premium_mode].each do |field|
        items << {:label => "case_#{app_status}_details_#{field}", :value => "case_#{app_status}_details_#{field}"} 
      end
    end
    
    return items.sort!{ |a,b| a[:value] <=> b [:value] }
  end

  def template_body_liquid_values
    items = {'profile_name' => 'profile.name',
     'connection_source_agency' => 'connection.source_agency',
     'connection | unsubscribe_href' => 'connection | unsubscribe_href',
     'case_current_details_face_amount | currency' => 'case.current_details.face_amount | currency'
    }

    %w[app_sent_at exam_date exam_time_of_day product_type_name effective_date].each do |case_field|
      items["case_#{case_field}"] = "case.#{case_field}"
    end

    %w[connection agent agent_of_record case_manager].each do |person|
      %w[first_name last_name title birth age anniversary].each do |field|
        items["#{person}_#{field}"] = "#{person}.#{field}"
      end
    end

    %w[connection agent case_manager agent_of_record profile].each do |has_contact_info|
      %w[email phone zip fax address city state].each do |field|
        items["#{has_contact_info}_#{field}"] = "#{has_contact_info}.#{field}" 
      end
    end

    %w[carrier_name policy_type.name].each do |current_details_field|
      items["case_current_details_#{current_details_field}"] = "case.current_details.#{current_details_field}"
    end

    %w[quoted submitted approved].each do |app_status|
      %w[carrier_name planned_modal_preium premium_mode].each do |field|
        items["case_#{app_status}_details_#{field}"] = "case.#{app_status}_details.#{field}"
      end
    end
    return items
  end

end
