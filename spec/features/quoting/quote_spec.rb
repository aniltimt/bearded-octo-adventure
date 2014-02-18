require 'spec_helper'
require 'support/feature_helpers.rb'
require 'support/lead_form_helpers.rb'
require 'rspec/mocks'
RSpec.configure do |config|
  config.include FeatureHelpers
  config.include LeadFormHelpers
end

describe 'New quote form' do

  DATE_PROC = lambda{|v| v.strftime(APP_CONFIG['date_format'])}

  before :each do
    FactoryGirl.create :usage_user_w_assoc, role_id:role_id
    ApplicationController.any_instance.stub(:current_user).and_return(current_user)
    current_user.should be_present
  end

  it 'should be fillable', js:true do
    # build objects
    @connection = FactoryGirl.build :crm_connection_w_assoc, health_info:FactoryGirl.build(:crm_health_info_questionable)
    @case = FactoryGirl.build :crm_case_w_assoc
    # load page
    load_page
    # verify panes
    page.should have_css '#quoter_pane', visible:true
    %w[initial_discovery advanced_discovery basic_info health].each do |pane|
      page.execute_script %Q(showFromSiblings('##{pane}');)
      page.should have_css "##{pane}", visible:true
    end
    # complete form
    fill_form
  end

  it 'should save a Crm::Connection', js:true do
    @connection = FactoryGirl.build :crm_connection_w_assoc, health_info:FactoryGirl.build(:crm_health_info_questionable)
    @case = FactoryGirl.build :crm_case_w_assoc
    @connection.agent = current_user
    # load page
    load_page
    # complete form
    fill_form
    # submit form
    click_on 'Save changes'
    # confirm Crm::Connections#personal page
    page.should have_selector '#connection-summary'
    page.should have_selector '#connection-id'
    crm_connection_id = find('#connection-id').text.to_i
    crm_connection = Crm::Connection.find(crm_connection_id)
    visit crm_health_info_path(crm_connection.health_info_id)
    [:feet, :inches, :birth, :gender, :weight, :cigarettes_per_month, :cigars_per_month, :last_cigar, :last_cigarette
      ].each do |field|
      value = @connection.health_info.read_attribute field
      value = value.to_date if value.is_a?(Time)
      value = value.strftime if value.is_a?(Date)
      unless value.blank?
        content = "#{field.to_s.humanize}: #{value}"
        page.should have_content(content), "Page lacks content #{field}: #{value}"
      end
    end
  end

  it 'should return quotes when "View rates" is clicked', js:true do
    @connection = FactoryGirl.build :crm_connection_w_assoc, birth:41.years.ago
    @case = FactoryGirl.build :crm_case_w_assoc
    @case.quoted_details.attributes = {face_amount:750000, health:'PP'}
    # load page
    load_page
    # complete form
    fill_form
    # submit form
    click_on 'View rates'
    # verify quotes pane
    page.should have_css '#quotes_pane', visible:true
    # verify quotes
    page.should have_selector '.quote'
    # select a quote
    within(first('.quote')) { click_on 'Apply' }
    # verify lead pane
    page.should have_css '#lead_pane', visible:true
    # complete lead pane form
    fill_lead_form
    # submit lead pane form
    within('#lead_pane'){ click_on 'Save changes' }
    # confirm Crm::Cases#details page
    page.should have_selector '#connection-summary'
    pending {
      within('ul#client-connection-tabs'){
        find('li.active').should have_content 'Policy'
      }
      within('ul#crm-case-detail-tabs'){
        find('li.active').should have_content 'Policy Details'
      }
      verify_policy
      verify_connection_personal
    }
  end

  # view-level helpers

  def fill_form
    fill_initial_discovery
    fill_basic_info_form
    fill_health_form
  end

  def load_page
    visit new_quoting_quote_path
    page.should_not have_content 'Login'
    page.should have_selector '#quoter_form'
    # remove data masks and fixed positions so that interacting with certain elements becomes possible
    page.execute_script "$('input.date').unmask()"
    page.execute_script "$('input[type=tel]').unmask()"
    page.execute_script "$('.navbar-fixed-top').css('position','relative')"
  end

  # pane-level helpers

  def fill_initial_discovery
    page.execute_script "$(window).scrollTop(0)"
    page.execute_script %q(showFromSiblings('#initial_discovery');)
    connection_filler = CapybaraHelpers::Filler.new page, [@connection, :connection]
    # existing coverage

    existing_coverage = [0,'replacing','adding'].sample
    choose "is_replacing_#{existing_coverage}"
    if ['adding','replacing'].include? @existing_coverage
      kase = Crm::Case.new
      existing_coverage_filler = connection_filler.child {prefix:'cases', object:kase, child_index:existing_coverage}, :approved_details
      existing_coverage_filler.fill_in :face_amount
      existing_coverage_filler.fill_in :carrier_name
      existing_coverage_filler.fill_in :years_until_termination_date
      if @existing_coverage == 'replacing'
        existing_coverage_filler.fill_in :monthly_premium
        choose 'monthly'
      end
    end
    # beneficiaries
    bene = FactoryGirl.build :crm_beneficiary
    benes = %w[spouse_partner children business other].sample
    bene_filler = CapybaraHelpers::Filler.new page, :crm_case, {prefix:'beneficiaries', object:bene, child_index:benes}
    choose "protect_whom_#{benes}"
    if %w[other].include? benes
      bene_filler.fill_in :relationship
    end
    if %w[spouse_partner business other].include? benes
      bene_filler.fill_in :name
    end
    if %w[spouse_partner children].include? benes
      within '#_marital_status' do
        fill_in 'child_count', with:rand(3)
      end
      CapybaraHelpers::Filler.select page, [@connection, :connection], :marital_status_id
      CapybaraHelpers::Filler.fill_in page, [@connection, :connection], :spouse, :full_name
    end
  end

  def fill_basic_info_form
    connection_filler = CapybaraHelpers::Filler.new page, [@connection, :connection]
    page.execute_script %q(showFromSiblings('#basic_info');)
    CapybaraHelpers::Filler.select page, [@connection, :connection], :contact_info, :state_id
    quote_filler = CapybaraHelpers::Filler.new page, [@case, :crm_case], :quoted_details
    quote_filler.select :category_id
    quote_filler.select :face_amount
    quote_filler.select :premium_mode_id
    connection_filler.choose :gender
    connection_filler.fill_in field: :birth, value:DATE_PROC
    health_filler = connection_filler.child :health_info
    health_filler.fill_in :feet
    health_filler.fill_in :inches
    health_filler.fill_in :weight
    health = @connection.health_info
    # tobacco
    if health.tobacco?
      choose 'tobacco_use_true'
      page.should have_css '#cigarettes_use', visible:true
      page.should have_css '#cigars_use', visible:true
      page.should have_css '#pipe_use', visible:true
      page.should have_css '#chewing_tobacco_use', visible:true
      page.should have_css '#patch_or_gum_use', visible:true
      if health.last_cigarette
        check 'cigarettes_use'
        health_filler.fill_in field: :last_cigarette, value:DATE_PROC
        health_filler.fill_in :cigarettes_per_month
      end
      if health.last_cigar
        check 'cigars_use'
        health_filler.fill_in field: :last_cigar, value:DATE_PROC
        health_filler.fill_in :cigars_per_month
      end
      if health.last_pipe
        check 'pipe_use'
        health_filler.fill_in field: :last_pipe, value:DATE_PROC
      end
      if health.last_tobacco_chewed
        check 'chewing_tobacco_use'
        health_filler.fill_in field: :last_tobacco_chewed, value:DATE_PROC
      end
      if health.last_nicotine_patch_or_gum
        check 'patch_or_gum_use'
        health_filler.fill_in field: :last_nicotine_patch_or_gum, value:DATE_PROC
      end
    else
      choose 'tobacco_use_false'
    end
  end

  def fill_health_form
    page.execute_script "$(window).scrollTop(0)"
    page.execute_script %q(showFromSiblings('#health');)
    connection_filler = CapybaraHelpers::Filler.new page, [@connection, :connection]
    health_filler = connection_filler.child :health_info
    health = @connection.health_info
    # blood pressure
    if health.bp?
      choose 'high_blood_pressure_true'
      health_filler.select :bp_systolic
      health_filler.select :bp_diastolic
      health_filler.fill_in field: :last_bp_treatment, value:DATE_PROC
      health_filler.fill_in :years_of_bp_control
    else
      choose 'high_blood_pressure_false'
    end
    # cholesterol
    if health.cholesterol?
      choose 'cholesterol_true'
      health_filler.select :cholesterol
      health_filler.select field: :cholesterol_hdl, value:lambda{|v| "%0.2f" % v}
      health_filler.fill_in field: :last_cholesterol_treatment, value:DATE_PROC
      health_filler.fill_in :years_of_cholesterol_control
    else
      choose 'cholesterol_false'
    end
    # driving history
    if health.driving_history?
      choose 'driving_history_true'
      [ :years_since_dui_dwi,
        :years_since_reckless_driving,
        :years_since_dl_suspension,
        :years_since_penultimate_car_accident
        ].each do |field|
        if health.send field
          health_filler.choose field
          health_filler.select field
        end
      end
      driving_filler = CapybaraHelpers::Filler.new page, [@connection, :connection], :health_info, :moving_violation_history
      driving_filler.fill_in :last_6_mo
      driving_filler.fill_in :last_1_yr
      driving_filler.fill_in :last_2_yr
      driving_filler.fill_in :last_3_yr
      driving_filler.fill_in :last_5_yr
    else
      choose 'driving_history_false'
    end
    # criminal history
    if health.criminal
      choose 'connection_health_info_attributes_criminal_true'
    else
      choose 'connection_health_info_attributes_criminal_false'
    end
    # avocation
    if health.hazardous_avocation
      choose 'connection_health_info_attributes_hazardous_avocation_true'
    else
      choose 'connection_health_info_attributes_hazardous_avocation_false'
    end
    # health history
    health.health_history.attributes.each do |k,v|
      if v
        next if %w[id created_at updated_at].include? k
        check "connection_health_info_attributes_health_history_attributes_#{k}" if v
      end
    end
    # family history
    if health.family_diseases.present?
      fill_in 'family_diseases_count', with: health.family_diseases.length
      click_on 'show fields'
      health.family_diseases.each_with_index do |relative,i|
        prefix = "connection_health_info_attributes_family_diseases_attributes_#{i}_"
        fill_in "#{prefix}age_of_contraction", with: relative.age_of_contraction
        fill_in "#{prefix}age_of_death", with: relative.age_of_death
        choose "#{prefix}parent_#{ relative.parent ? 1 : 0 }"
        [ :age_of_contraction, :age_of_death, :basal_cell_carcinoma, 
          :breast_cancer, :cardiovascular_disease, 
          :cardiovascular_impairments, 
          :cerebrovascular_disease, :colon_cancer, 
          :coronary_artery_disease, :diabetes, :intestinal_cancer, 
          :kidney_disease, :malignant_melanoma, 
          :other_internal_cancer, :ovarian_cancer, 
          :prostate_cancer
          ].each do |disease|
            check "#{prefix}#{disease}" if relative.send(disease)
          end
      end
    end
    # residency
    if @connection.citizenship.try(:name) == 'US Citizen'
      choose 'citizenship_true'
    else
      choose 'citizenship_false'
      connection_filler.select :citizenship_id
    end
    # bankruptcy
    if @connection.financial_info.bankruptcy
      financial_filler = connection_filler.child :financial_info
      choose 'bankruptcy_true'
      financial_filler.fill_in :bankruptcy
      if @connection.financial_info.bankruptcy_discharged
        choose 'bankruptcy_discharged_true'
        financial_filler.fill_in :bankruptcy_discharged
      else
        choose 'bankruptcy_discharged_false'
      end
    else
      choose 'bankruptcy_false'
    end
  end

  # very deep helpers

  def assert_matching_objs obj1, obj2, fields_to_exclude=[]
    obj1.attributes.each do |k,saved_v|
      next if fields_to_exclude.include?(k)
      expected_v = obj2.send(k)
      saved_v.should eq(expected_v), "New and latest connection have mismatch for field #{k}. Expected #{expected_v}, got #{saved_v}"
    end 
  end

end
