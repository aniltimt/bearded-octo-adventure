module TaskHelpers
  class EzLifeControlCodeCreator
    def create_control_codes
      codes = []
      codes << {carrier: "American General", esign: true, control_code: 4518, company_code: "KPM"}
      codes << {carrier: "American General", esign: false, control_code: 3199, company_code: "NOOH"}

      codes << {carrier: "National", esign: true, control_code: 4971, company_code: "NOOI"}
      codes << {carrier: "National", esign: false, control_code: 3196, company_code: "NOOJ"}

      codes << {carrier: "MetLife", esign: true, control_code: 4998, company_code: "OOOR"}
      codes << {carrier: "MetLife", esign: false, control_code: 4999, company_code: "OOOS"}

      codes << {carrier: "MinLife", esign: true, control_code: 4527, company_code: "BOOV"}
      codes << {carrier: "MinLife", esign: false, control_code: 4990, company_code: "NOOY"}

      codes << {carrier: "Nationwide", esign: true, control_code: 4528, company_code: "OOOF"}
      codes << {carrier: "Nationwide", esign: false, control_code: 4991, company_code: "OOOG"}

      codes << {carrier: "NorthAm", esign: true, control_code: 4529, company_code: "BOOU"}
      codes << {carrier: "NorthAm", esign: false, control_code: 4992, company_code: "OOOH"}

      codes << {carrier: "ProtLife", esign: true, control_code: 4993, company_code: "OOOI"}
      codes << {carrier: "ProtLife", esign: false, control_code: 3206, company_code: "OOOJ"}

      codes << {carrier: "Prudential", esign: true, control_code: 4530, company_code: "BOOL"}
      codes << {carrier: "Prudential", esign: false, control_code: 4995, company_code: "OOOL"}

      codes << {carrier: "SBLI", esign: true, control_code: 4965, company_code: "MOOY"}
      codes << {carrier: "SBLI", esign: false, control_code: 4966, company_code: "MOOZ"}

      codes << {carrier: "AXA", esign: true, control_code: 4975, company_code: "NOOS"}
      codes << {carrier: "AXA", esign: false, control_code: 3198, company_code: "NOOT"}

      codes << {carrier: "Banner", esign: true, control_code: 4521, company_code: "KPL"}
      codes << {carrier: "Banner", esign: false, control_code: 3200, company_code: "MOOT"}

      codes << {carrier: "Centrian", esign: true, control_code: 4963, company_code: "NOOU"}
      codes << {carrier: "Centrian", esign: false, control_code: 4964, company_code: "NOOV"}

      codes << {carrier: "Companion", esign: true, control_code: 4976, company_code: "NOOW"}
      codes << {carrier: "Companion", esign: false, control_code: 3201, company_code: "NOOX"}

      codes << {carrier: "ING", esign: true, control_code: 4977, company_code: "OOOQ"}
      codes << {carrier: "ING", esign: false, control_code: 4978, company_code: "NOOZ"}

      codes << {carrier: "OmahaLife", esign: true, control_code: 4535, company_code: "BOOR"}
      codes << {carrier: "OmahaLife", esign: false, control_code: 4996, company_code: "OOOM"}

      codes << {carrier: "USLife", esign: true, control_code: 4536, company_code: "BOOQ"}
      codes << {carrier: "USLife", esign: false, control_code: 4997, company_code: "ODON"}

      codes << {carrier: "Assurity", esign: true, control_code: 4734, state: "CA", company_code: "NOOM"}
      codes << {carrier: "Assurity", esign: true, control_code: 4974, state: "FL", company_code: "NOOO"}
      codes << {carrier: "Assurity", esign: true, control_code: 4972, company_code: "NOOK"}
      codes << {carrier: "Assurity", esign: false, control_code: 4973, state: "CA", company_code: "NOON"}
      codes << {carrier: "Assurity", esign: false, control_code: 4735, state: "FL", company_code: "NOOP"}
      codes << {carrier: "Assurity", esign: false, control_code: 3197, company_code: "NOOL"}

      codes << {carrier: "AVIVA", esign: true, control_code: 5420, state: "NY", company_code: "SOOV"}
      codes << {carrier: "AVIVA", esign: true, control_code: 5421, company_code: "SOOW"}
      codes << {carrier: "AVIVA", esign: false, control_code: 3204, state: "NY", company_code: "NOOQ"}
      codes << {carrier: "AVIVA", esign: false, control_code: 3203, company_code: "NOOR"}

      codes << {carrier: "Genworth", esign: true, control_code: 4957, state: "NY", company_code: "MOOP"}
      codes << {carrier: "Genworth", esign: true, control_code: 4959, company_code: "MOOR"}
      codes << {carrier: "Genworth", esign: false, control_code: 4958, state: "NY", company_code: "MOOQ"}
      codes << {carrier: "Genworth", esign: false, control_code: 4960, company_code: "MOOS"}

      codes << {carrier: "JohnHancock", esign: true, control_code: 4967, state: "NY", company_code: "MOOU"}
      codes << {carrier: "JohnHancock", esign: true, control_code: 4969, company_code: "MOOW"}
      codes << {carrier: "JohnHancock", esign: false, control_code: 4968, state: "NY", company_code: "MOOV"}
      codes << {carrier: "JohnHancock", esign: false, control_code: 4970, company_code: "MOOX"}

      codes << {carrier: "Transamerica", esign: true, control_code: 4982, state: "NY", company_code: "NOOD"}
      codes << {carrier: "Transamerica", esign: true, control_code: 4534, company_code: "BOOS"}
      codes << {carrier: "Transamerica", esign: false, control_code: 4983, state: "NY", company_code: "NOOE"}
      codes << {carrier: "Transamerica", esign: false, control_code: 4984, company_code: "NOOA"}

      codes.each do |code|
        create_control_code(code)
      end
    end

    private

    def create_control_code(params)
      Processing::ExamOne::ControlCode.create(params.merge({ez_life_profile: true}))
    end
  end
end
