require 'spec_helper'
require 'support/feature_helpers.rb'

RSpec.configure do |config|
  config.include FeatureHelpers
end

describe 'static page' do

  describe 'Sales Tools' do

    before :each do
      visit '/'
      click_on 'Help'
      within("#top_tab") do
        click_on 'Sales Tools'
      end
    end
    
    it "should display 'Productivity'", js:true do
      click_on 'Productivity'
      assert page.has_text?('Agent Website')
      assert page.has_text?('Client Management (CRM)')
      assert page.has_text?('Conference Desktop Sharing')
      assert page.has_text?('Predicative / Auto-Dialer')
    end

    it "should display 'Quoters'", js:true do
      sleep 2
      click_on 'Quoters'
      assert page.has_text?('Life')
      assert page.has_text?('Annuities')
    end
    
    it "should display 'Financial Calculators'", js:true do
      click_on 'Financial Calculators'
      page.should have_content 'Wealth Transfer and Legacy Planning'
      page.should have_content 'Retirement Income Planning'
    end

    it "should display 'Contracting'", js:true do
      click_on 'Contracting'
    end

    it "should display 'Training'", js:true do
      sleep 2
      click_on 'Training'
      assert page.has_text?('Professional Development')
      assert page.has_text?('Required Training')
      assert page.has_text?('Sales Training')
    end
        
    it "should display 'Planning'", js:true do
      click_on 'Planning'
      assert page.has_text?('Advanced Markets Online Library')
    end
  end
  
  describe 'Help' do

    before :each do
      visit '/'
      click_on 'Help'
      sleep 2
    end
    
    it 'should display FAQs', js:true do
      page.should have_content 'Frequently Asked Questions'
      
      page.should have_content 'How do I complete agent contracting with a specific carrier?'

      page.should have_content 'Do I need to complete a paper application, schedule exams & labs, or order APS records?'

      page.should have_content 'How are agent signatures collected and affixed to applications submitted through EZLife?'

      page.should have_content 'How are client signatures collected and affixed to applications submitted through EZLife?'

      page.should have_content 'What happens if a health issue or avocation prevents the EZLife system from generating a valid quote?'

      page.should have_content 'On the EZLife client quote section of the website, why do some carriers show up more than once?'

      page.should have_content 'How can I check case status or see the progress of a specific case?'

      page.should have_content 'How do I login to the case status portion of the EZLife.com website?'
    end
    
    it 'should display tutorials', js:true do
      click_on 'Tutorials'
      page.should have_content 'Coming Soon!'
    end
    
    it 'should display Help', js:true do
      within("#main-container .nestedTabbedArea") do
        click_on 'Help'
      end
      page.should have_content 'Coming Soon!'
    end
    
    it 'should display Suggestions', js:true do
      click_on 'Suggestions'
      page.should have_content 'We Welcome Feedback!'
      fill_in 'suggestion', :with => "Here is my test feedback!"
    end

  end

  describe 'Underwriter' do

    before :each do
      visit '/'
      click_on 'Help'
      click_on 'Underwriting'
      sleep 2
    end
    
    it "should display 'Ask the Underwriter'", js:true do
      click_on 'Ask the Underwriter'
      page.should have_content 'Ask an Underwriting Question'
      page.should have_content 'Email Your Underwriting Question'
    end

    it "should display 'Guides'", js:true do
      click_on 'Guides'
      assert page.has_text?('Each carrier has their own underwriting guidelines and niches. Below are the published guides from many of the carriers available through the EZLife process. For more in-depth help please use the XRAE health screening tool or contact the EZLife underwriting team.')
    end

    it "should display 'Questionnaires'", js:true do
      click_on 'Questionnaires'
      assert page.has_text?('Impairment/A.T.U.')
      assert page.has_text?('Questionnaire	Rx')
      assert page.has_text?('Matrix')
      assert page.has_text?('XRAE')
      assert page.has_text?('E-mail')
    end

    it "should display 'XRAE'", js:true do
      click_on 'XRAE'
      assert page.has_text?('The multi-carrier XRAE health screening tool was designed to help you with the initial collection and analysis of client medical information. XRAE will help you build each sale on a solid foundation by guiding you through the collection of important data, the accurate application of carrier underwriting rules, and the quoting of the correct underwriting class and pricing.')
    end

    it "should display 'Table Shave Programs'", js:true do
      click_on 'Table Shave Programs'
      assert page.has_text?("Underwriting guides are subject to change without notice. For agent use only. This is not an offer for life insurance.")
    end
  end
end
