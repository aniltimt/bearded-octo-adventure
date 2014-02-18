module ApplicationHelper

  # Returns selector for the container whose contents
  # shall be replaced by an AJAX response. Defaults to
  # '#main-container'
  def container
    ( @container_to_be_replaced ||
      params[:container] ||
      (params[:container_id] ? "##{params[:container_id]}" : nil) ||
      '#main-container'
      ).html_safe
  end

  def strf_date(date_obj)
    date_obj.strftime("%d/%m/%y") rescue nil
  end

  def strfdate(date_obj)
    date_obj.strftime("%m/%d/%Y") rescue nil
  end

  def get_connection_primary_contact(crm_connection)
    if crm_connection.primary_contact
      "<a data-remote='true' href='/crm/connections/personal?connection_id=#{crm_connection.primary_contact_id}'>
        #{crm_connection.primary_contact.try(:full_name)}
      </a>".html_safe
    else
      crm_connection.try(:full_name)
    end
  end

  def get_field_name_for_inline_editing(field)
    field.blank? ? 'Empty' : field
  end

  def suspension_status(usr)
    if usr.agent_field_set.temporary_suspension
      '<i class="icon-play green"></i>'.html_safe
    else
      '<i class="icon-pause red"></i>'.html_safe
    end
  end

  def user_email(message)
    unless message.user.blank?
      unless message.user.contact_info.blank?
        message.user.contact_info.emails.blank? ? nil : message.user.contact_info.emails.first
      end
    end
  end

  def connection_email(message)
    unless message.crm_connection.blank?
      unless message.crm_connection.contact_info.blank?
        message.crm_connection.contact_info.emails.blank? ? nil : message.crm_connection.contact_info.emails.first
      end
    end
  end

  def receiver_emails(message)
    emails = []
    connection_email = connection_email(message)
    user_email = user_email(message)
    emails << '<p>'+"#{connection_email.value}" unless connection_email.try(:value).blank?
    emails << "#{user_email.value}" unless user_email.try(:value).blank?
    emails << "#{message.recipient}"+'</p>' unless message.recipient.blank?
    return emails.join(',')
  end
end
