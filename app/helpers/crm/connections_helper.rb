module Crm::ConnectionsHelper

  def client_management_tab label, url, options={}, li_options={}
    url += url.include?('?') ? '&' : '?'
    url += 'container_id=crm-connection-summary'
    # add default classes
    if options[:class]
      options[:class] << " ajax"
    else
      options[:class] = 'ajax'
    end
    # merge default options for <a>
    options = {
      'data-toggle' => 'tab',
      remote: true
      }.merge options
    # handle 'active' class for <li>
    pattern = li_options.delete :active_if
    if pattern.present?
      if pattern == params[:connection_tab] or
        (pattern.is_a? Array and pattern.include? params[:connection_tab])
        li_options[:class] = 'active'        
      end
    end
    # build <li><a></a></li>
    content_tag :li, link_to(label, url, options), li_options
  end

end
