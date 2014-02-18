module Crm::CrmBaseHelper

  def send_case_or_connection_id_in_params
    if @crm_case.present?
      {:case_id => @crm_case.id}
    else
      {:connection_id => @crm_connection.id}
    end
  end

  def get_tagging_tag_name(tag)
    tag.tag_key.try(:name) + ("=#{tag.tag_value.try(:value)}" if tag.tag_value.try(:value)).to_s
  end
end
