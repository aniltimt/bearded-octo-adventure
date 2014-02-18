require 'support/capybara_helpers'

module LeadFormHelpers

  def fill_lead_form
    page.execute_script "$('input.date').unmask()"
    page.execute_script "$('input[type=tel]').unmask()"
    page.execute_script "$('.navbar-fixed-top').css('position','relative')"
    pending "@connection needs to be created in the test" unless @connection.present?
    connection_filler = CapybaraHelpers::Filler.new page, [@connection, :crm_connection]
    connection_filler.fill_in :first_name
    connection_filler.fill_in :middle_name
    connection_filler.fill_in :last_name
    connection_filler.fill_in :birth_country
    connection_filler.fill_in :dln
    connection_filler.fill_in :ssn
    connection_filler.fill_in :occupation
    connection_filler.select :birth_state_id
    connection_filler.select :dl_state_id
    connection_filler.select :citizenship_id
    connection_filler.choose :gender
    contact_info_filler = connection_filler.child :contact_info
    contact_info_filler.fill_in :address_value
    contact_info_filler.fill_in :city
    contact_info_filler.select :state_id
    contact_info_filler.fill_in :zip
    contact_info_filler.fill_in :home_phone_value
    contact_info_filler.fill_in :work_phone_value
    contact_info_filler.fill_in :work_phone_ext
    contact_info_filler.fill_in :cell_phone_value
    contact_info_filler.fill_in :fax
    contact_info_filler.fill_in :preferred_contact_time
    contact_info_filler.select :preferred_contact_method_id
    contact_info_filler.fill_in :email_value
    contact_info_filler.fill_in :company
    pending "@case needs to be created in the test" unless @case.present?
    case_filler = CapybaraHelpers::Filler.new page, [@case, :crm_case]
    case_filler.fill_in :reason
    financial_info_filler = connection_filler.child :financial_info
    financial_info_filler.fill_in :income
    financial_info_filler.fill_in :asset_total
    financial_info_filler.fill_in :liability_total
    case_filler.choose :esign
    case_filler.choose :bind
    if @connection.cases.present?
      @connection.cases.each_with_index do |kase, i|
        # todo
      end
    end
  end

  def verify_connection_personal
    click_on 'Personal'
    pending {
      page.should have_content @connection.first_name
      page.should have_content @connection.last_name
    }
  end

  def verify_policy
    pending {
      find('#crm-case-quoted-details-carrier').value.should be @case.quoted_details.carrier_name
    }
  end

end