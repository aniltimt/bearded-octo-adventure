module TaskHelpers
  class WholesaleControlCodeCreator
    def create_control_codes
      codes = []
      codes << {carrier: "Banner", esign: true, control_code: 5364, company_code: "QOOT"}
      codes << {carrier: "Banner", esign: false, control_code: 5363, company_code: "QOOS", take_out_packet: true}
      codes << {carrier: "Banner", esign: false, control_code: 5362, company_code: "QOOR", take_out_packet: false}

      codes << {carrier: "Genworth", esign: true, control_code: 4523, company_code: "DOOA"}
      codes << {carrier: "Genworth", esign: true, control_code: 4524, company_code: "LOOW", state: "NY"}
      codes << {carrier: "Genworth", esign: false, control_code: 3202, company_code: "LOOQ"}
      codes << {carrier: "Genworth", esign: false, control_code: 4943, company_code: "LOOV", state: "NY"}

      codes << {carrier: "ING", esign: true, control_code: 4526, company_code: "LOOT"}
      codes << {carrier: "ING", esign: false, control_code: 4525, company_code: "LOOS"}

      codes << {carrier: "Metlife", esign: false, control_code: 5322, company_code: "OOOW", policy_type: "Disability"}
      codes << {carrier: "Metlife", esign: false, control_code: 4712, company_code: "GOOX"}

      codes << {carrier: "Prudential", esign: true, control_code: 5361, company_code: "QOOW"}
      codes << {carrier: "Prudential", esign: false, control_code: 5360, company_code: "QOOV", take_out_packet: true}
      codes << {carrier: "Prudential", esign: false, control_code: 5359, company_code: "QOOU", take_out_packet: false}

      codes << {carrier: "SBLI", esign: true, control_code: 4533, company_code: "LOOU"}
      codes << {carrier: "SBLI", esign: false, control_code: 4944, company_code: "BOOH"}

      codes.each do |code|
        create_control_code(code)
      end
    end

    private

    def create_control_code(params)
      Processing::ExamOne::ControlCode.create(params.merge({ez_life_profile: false}))
    end
  end
end

