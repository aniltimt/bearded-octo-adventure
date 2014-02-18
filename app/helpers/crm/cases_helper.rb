module Crm::CasesHelper

  CASE_NAV_URL_DEFAULTS = {controller:'/crm/cases', id:@crm_case}
  CASE_NAV_HTML_DEFAULTS = {remote:true}

  def case_nav_item label, url_options={}, html_options={}, li_options={}
    content_tag :li, link_to(label, url_options, html_options), li_options
  end

end
