class Quoting::PinneyQuoter::Quote < ActiveResource::Base
  self.site = PINNEYQUOTER_SITE
  set_element_name = 'quote'
  set_collection_name = 'quotes'
  self.format = ActiveResource::Formats::XmlFormat

  COMPULIFE_DEFAULT_HEALTH = 'PP'

  # Used for calculating the 'suffix' for sending RelativeDisease info to Compulife
  @@compulife_relative_disease_suffix_counter_0 = 0
  @@compulife_relative_disease_suffix_counter_1 = 0

  def self.build_simple kase
    # make convenience vars
    conn = kase.crm_connection
    health = conn.health_info
    res = kase.quoted_details
    # build Quoter
    q = self.new
    q.client = {
      feet: health.feet,
      state_id: conn.contact_info.state.id,
      health: res.health_class.try(:value),
      sex: pq_gender(conn.gender),
      weight: health.weight,
      dateOfBirth: conn.birth,
      inches: health.inches,
      smoker: period_cigarettes(health)
    }
    q.quote_params = [{
      userLocation: 'XML',
      termCategory: res.category.compulife_code,
      quote_type: 'term',
      faceAmount: res.face_amount
      }]
    return q
  end

  def self.build_complex kase
    # make convenience vars
    conn = kase.crm_connection
    health = conn.health_info
    res = kase.quoted_details
    # build Quoter
    q = self.build_simple(kase)
    q.health_analyzer = {
      # blood pressure
      systolic: health.bp_systolic,
      dystolic: health.bp_diastolic,
      periodBloodPressure: health.years_since_bp_treatment,
      periodBloodPressureControl: health.years_of_bp_control,
      # cholesterol
      cholesterolLevel: health.cholesterol,
      hdlRatio: health.cholesterol_hdl,
      periodCholesterol: health.years_since_cholesterol_treatment,
      periodCholesterolControl: health.years_of_cholesterol_control,
      # family history
      'FamilyHistories' => health.family_diseases.map{ |individual| build_pq_family_history(individual) },
      numDeaths: health.family_diseases.where('age_of_death IS NOT NULL').count,
      numContracted: health.family_diseases.count,
      # driving history
      'DrivingHistory' => {
        periodDwiConviction: health.years_since_dui_dwi,
        periodMoreThanOneAccident: health.years_since_penultimate_car_accident,
        periodRecklessConviction: health.years_since_reckless_driving,
        periodSuspendedConviction: health.years_since_dl_suspension,
        movingViolation0: health.moving_violation_history.try(:last_6_mo),
        movingViolation1: health.moving_violation_history.try(:last_1_yr),
        movingViolation2: health.moving_violation_history.try(:last_2_yr),
        movingViolation3: health.moving_violation_history.try(:last_3_yr),
        movingViolation4: health.moving_violation_history.try(:last_5_yr)
      },
      # tobacco
      numCigarettes: health.cigarettes_per_month,
      periodCigarettes: health.years_since_last_cigarette,
      numCigars: health.cigars_per_month,
      periodCigars: health.years_since_last_cigar,
      periodPipe: health.years_since_last_pipe,
      periodChewingTobacco: health.years_since_last_tobacco_chewed,
      periodNicotinePatchesOrGum: health.years_since_last_nicotine_patch_or_gum
    }
    # get rid of nils
    q.client.reject!{|k,v| v.blank?}
    q.quote_params[0].reject!{|k,v| v.blank?}
    q.health_analyzer.reject!{|k,v| v.blank?}
    q.health_analyzer[:drivingHistory].reject!{|k,v| v.blank?} if q.health_analyzer[:drivingHistory]
    # set default health
    q.client[:health] ||= COMPULIFE_DEFAULT_HEALTH
    # return
    return q
  end

  def self.fetch_results kase
    quote = self.build_complex kase
    quote.save
    results = quote.results.result rescue []
    results
  rescue Errno::ECONNREFUSED => error
    Rails.logger.error error.message
    Rails.logger.error quote.class.site
    File::open('tmp/quote-request.xml','w'){|f| f.puts quote.to_xml}
    SystemMailer.error_email(error, "Site is #{quote.class.site}").deliver
  end

  private

  def self.build_pq_family_history individual
    {
      suffix: '',
      ageDied: individual.age_of_death,
      ageContracted: individual.age_of_contraction,
      isParent: individual.parent,
      cad: individual.coronary_artery_disease,
      cva: individual.cerebrovascular_disease,
      cvd: individual.cardiovascular_disease,
      cvi: individual.cardiovascular_impairments,
      diabetes: individual.diabetes,
      kidneyDisease: individual.kidney_disease,
      colonCancer: individual.colon_cancer,
      intestinalCancer: individual.intestinal_cancer,
      breastCancer: individual.breast_cancer,
      prostateCancer: individual.prostate_cancer,
      ovarianCancer: individual.ovarian_cancer,
      otherInternalCancer: individual.other_internal_cancer,
      basalCellCarcinoma: individual.basal_cell_carcinoma
    }
  end

  def self.pq_gender gender
    case gender
    when true
      'M'
    when false
      'F'
    end
  end

  def self.period_cigarettes health
    case health.years_since_last_cigarette
    when nil
      -1
    when 0
      health.last_cigarette >= 1.month.ago ? 0 : 1
    when (1..2)
      1 + health.years_since_last_cigarette
    when (3..4)
      4
    when (5..9)
      5
    else
      7
    end
  end

end
