require 'spec_helper'

describe 'PinneyQuoter interface' do

  describe 'with good, hand-made data' do

    it 'yields results' do
      @q = Quoting::PinneyQuoter::Quote.new
      @q.client = {
        feet: 5,
        state_id: 13,
        health: 'PP',
        sex: 'M',
        weight: 165,
        dateOfBirth: 40.years.ago,
        inches: 11,
        smoker: -1
      }
      @q.quote_params = [{
        userLocation: 'XML',
        termCategory: 5,
        quote_type: 'term',
        faceAmount: 750000
        }]
      @q.save
      has_valid_results @q
    end

  end

  describe 'with simple builder' do
  
    it 'yields results' do
      pending "Broken"
      # build objects for fetching results
      @case = FactoryGirl.build :crm_case_w_assoc
      @case.crm_connection = FactoryGirl.build :crm_connection_w_assoc
      @case.quoted_details.attributes = {
        face_amount:7500000,
        category:Quoting::TliCategoryOption.find(3),
        premium_mode:Quoting::PremiumModeOption.first,
        health_class:Quoting::TliHealthClassOption.first
      }
      @quoter = Quoting::PinneyQuoter::Quote.build_simple @case
      @quoter.save
      has_valid_results @quoter
    end

  end

  describe 'with health analyzer (complex builder)' do

    it 'yields results' do
      pending "Broken"
      # build objects for fetching results
      @case = FactoryGirl.build :crm_case_w_assoc
      @case.crm_connection = FactoryGirl.build :crm_connection_w_assoc
      @case.quoted_details.attributes = {
        face_amount:7500000,
        category:Quoting::TliCategoryOption.find(3),
        premium_mode:Quoting::PremiumModeOption.first,
        health_class:Quoting::TliHealthClassOption.first
      }
      @results = Quoting::PinneyQuoter::Quote::fetch_results @case
      @results.should be_a Array
      @results.first.should be_a Quoting::PinneyQuoter::Results::Result
    end

  end

  def has_valid_results quoter
    quoter.should respond_to :results
    quoter.results.should respond_to :result
    quoter.results.result.should be_a Array
    quoter.results.result.first.should be_a Quoting::PinneyQuoter::Results::Result
  end

end
