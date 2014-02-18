require "spec_helper"
require "debugger"

describe Processing::ExamOne do
  let!(:exam_one) { Processing::ExamOne.new }

  describe "#build_and_send_or01" do
    let(:order_record_generator) { fire_double("Processing::ExamOne::OrderRecordGenerator", generate: "order record") }
    let(:order_notes_generator) { fire_double("Processing::ExamOne::OrderNotesGenerator", generate: "order notes") }
    let(:applicant_record_part_one_generator) { fire_double("Processing::ExamOne::ApplicantRecordPartOneGenerator", generate: "part 1") }
    let(:applicant_record_part_two_generator) { fire_double("Processing::ExamOne::ApplicantRecordPartTwoGenerator", generate: "part 2") }
    let(:applicant_record_part_three_generator) { fire_double("Processing::ExamOne::ApplicantRecordPartThreeGenerator", generate: "part 3") }
    let(:applicant_record_part_four_generator) { fire_double("Processing::ExamOne::ApplicantRecordPartFourGenerator", generate: "part 4") }
    let(:insurance_company_information_generator) { fire_double("Processing::ExamOne::InsuranceCompanyInformationGenerator", generate: "insurance company") }
    let(:policy_information_generator) { fire_double("Processing::ExamOne::PolicyInformationGenerator", generate: "policy information") }
    let(:exam_appointment_generator) { fire_double("Processing::ExamOne::ExamAppointmentGenerator", generate: "exam appointment") }
    let(:total_generator) { fire_double("Processing::ExamOne::TotalGenerator", generate: "total") }
    let(:or01_validator) { fire_double("Processing::ExamOne::Or01Validator") }
    let(:or01_sender) { fire_double("Processing::ExamOne::Or01Sender") }
    let(:control_code_determiner) { fire_double("Processing::ExamOne::ControlCodeDeterminer") }

    let(:crm_connection) { fire_double("Crm::Connection", contact_info: contact_info) }
    let(:contact_info) { fire_double("ContactInfo", state: state) }
    let(:state) { fire_double("State", abbrev: "CA") }
    let(:crm_case) { fire_double("Crm::Case") }
    let(:payload) { "order record\norder notes\npart 1\npart 2\npart 3\npart 4\ninsurance company\npolicy information\nexam appointment\ntotal" }

    before do
      Processing::ExamOne::OrderRecordGenerator.stub(:new).and_return(order_record_generator)
      Processing::ExamOne::OrderNotesGenerator.stub(:new).and_return(order_notes_generator)
      Processing::ExamOne::ApplicantRecordPartOneGenerator.stub(:new).and_return(applicant_record_part_one_generator)
      Processing::ExamOne::ApplicantRecordPartTwoGenerator.stub(:new).and_return(applicant_record_part_two_generator)
      Processing::ExamOne::ApplicantRecordPartThreeGenerator.stub(:new).and_return(applicant_record_part_three_generator)
      Processing::ExamOne::ApplicantRecordPartFourGenerator.stub(:new).and_return(applicant_record_part_four_generator)
      Processing::ExamOne::InsuranceCompanyInformationGenerator.stub(:new).and_return(insurance_company_information_generator)
      Processing::ExamOne::PolicyInformationGenerator.stub(:new).and_return(policy_information_generator)
      Processing::ExamOne::ExamAppointmentGenerator.stub(:new).and_return(exam_appointment_generator)
      Processing::ExamOne::TotalGenerator.stub(:new).and_return(total_generator)
      Processing::ExamOne::Or01Validator.stub(:new).and_return(or01_validator)
      Processing::ExamOne::Or01Sender.stub(:new).and_return(or01_sender)
      Processing::ExamOne::ControlCodeDeterminer.stub(:new).and_return(control_code_determiner)
      control_code_determiner.stub(:determine_company_code).and_return("12345")
    end

    context "when the information does not pass validation" do
      before do
        or01_validator.stub(:validate).with(crm_connection, crm_case).and_return(["error1", "error2"])
      end

      it "raises an invalid information error with the errors given" do
        expect { exam_one.build_and_send_or01(crm_connection, crm_case) }.to raise_error(Processing::ExamOne::InvalidInformationError, "error1, error2")
      end
    end

    context "when the information passes validation" do
      before do
        or01_validator.stub(:validate).with(crm_connection, crm_case).and_return([])
        or01_sender.stub(:send_or01).and_return([])
      end

      it "generates an order record string" do
        order_record_generator.should_receive(:generate).with(crm_case)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates an order notes string" do
        order_notes_generator.should_receive(:generate).with(crm_connection)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the first part of the applicant_record string" do
        applicant_record_part_one_generator.should_receive(:generate).with(crm_connection)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the second part of the applicant_record string" do
        applicant_record_part_two_generator.should_receive(:generate).with(crm_connection)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the third part of the applicant_record string" do
        applicant_record_part_three_generator.should_receive(:generate).with(crm_connection)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the fourth part of the applicant_record string" do
        applicant_record_part_four_generator.should_receive(:generate).with(crm_connection)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "determines the company code" do
        control_code_determiner.should_receive(:determine_company_code).with(crm_case, "CA")
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the insurance company information" do
        insurance_company_information_generator.should_receive(:generate).with(crm_case, "12345")
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the policy information" do
        policy_information_generator.should_receive(:generate).with(crm_connection, crm_case)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the exam appointment" do
        exam_appointment_generator.should_receive(:generate).with(crm_case)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      it "generates the total" do
        total_generator.should_receive(:generate)
        exam_one.build_and_send_or01(crm_connection, crm_case)
      end

      context "when the or01 send is successful" do
        before do
          or01_sender.stub(:send_or01).with(payload).and_return([])
        end

        it "does not raise an error" do
          expect { exam_one.build_and_send_or01(crm_connection, crm_case) }.to_not raise_error
        end
      end

      context "when the or01 send is unsuccessful" do
        before do
          or01_sender.stub(:send_or01).with(payload).and_return(["error"])
        end

        it "raises an or01 send error" do
          expect { exam_one.build_and_send_or01(crm_connection, crm_case) }.to raise_error(Processing::ExamOne::Or01SendError, "error")
        end
      end
    end
  end

  describe "#get_statuses" do
    let(:or01_parser) { fire_double("Processing::ExamOne::Or01Parser") }
    let(:ftp) { stub }
    let!(:file) { File.open("#{Rails.root}/tmp/testfile.out", "w+") { |file| file.write("lol") } }

    before do
      Net::FTP.stub(:new).with("xfer.labone.com").and_return(ftp)
      ftp.stub(:login)
      ftp.stub(:passive=)
      ftp.stub(:chdir)
      ftp.stub(:getbinaryfile)
      Processing::ExamOne::Or01Parser.stub(:new).and_return(or01_parser)
      or01_parser.stub(:parse_info)
      ftp.stub(:nlst).with("*.PGP").and_return(["testfile"])
    end

    after do
      File.delete("#{Rails.root}/tmp/testfile.out")
    end

    it "makes a login into the ftp" do
      ftp.should_receive(:login).with("pinney", "YbjV8dl1")
      exam_one.get_statuses
    end

    it "sets the passive on the ftp" do
      ftp.should_receive(:passive=).with(true)
      exam_one.get_statuses
    end

    it "changes the directory to outgoing" do
      ftp.should_receive(:chdir).with("outgoing")
      exam_one.get_statuses
    end

    it "gets the file using ftp" do
      ftp.should_receive(:getbinaryfile).with("testfile", "#{Rails.root}/tmp/testfile")
      exam_one.get_statuses
    end

    it "parses the file from the ftp" do
      or01_parser.should_receive(:parse_info).with("lol")
      exam_one.get_statuses
    end
  end

  describe "#schedule_url" do
    let(:control_code_determiner) { fire_double("Processing::ExamOne::ControlCodeDeterminer") }
    let(:crm_connection) { fire_double("Crm::Connection", first_name: "test", last_name: "user", contact_info: contact_info, health_info: health_info) }
    let(:health_info) { fire_double("Crm::HealthInfo", gender: gender) }
    let(:contact_info) { fire_double("ContactInfo", state: state, address_value: "123 street", city: "hereville", email_value: "test@test.com") }
    let(:crm_case) { fire_double("Crm::Case", id: 42) }
    let(:gender) { "Male" }
    let(:state) { fire_double("State", abbrev: "CA") }

    before do
      Processing::ExamOne::ControlCodeDeterminer.stub(:new).and_return(control_code_determiner)
      control_code_determiner.stub(:determine_control_code).and_return("1234")
    end

    it "determines the control code" do
      control_code_determiner.should_receive(:determine_control_code).with(crm_case, "CA")
      exam_one.schedule_url(crm_connection, crm_case)
    end

    context "when the crm_connection's gender is male" do
      it "builds the schedule url" do
        exam_one.schedule_url(crm_connection, crm_case).should == "http://test.com?control_code=1234&control_num=42&fname=test&lname=user&addr=123+street&city=hereville&state=CA&zip=99999&gender=0&email=test@test.com"
      end
    end

    context "when the crm_connection's gender is not male" do
      let(:gender) { "Potato" }

      it "builds the schedule url" do
        exam_one.schedule_url(crm_connection, crm_case).should == "http://test.com?control_code=1234&control_num=42&fname=test&lname=user&addr=123+street&city=hereville&state=CA&zip=99999&gender=1&email=test@test.com"
      end
    end

    context "when the crm_connection's state is longer than 2 characters (NY-B or NY-NB)" do
      let(:state) { fire_double("State", abbrev: "NY-NB") }

      it "builds the schedule url" do
        exam_one.schedule_url(crm_connection, crm_case).should == "http://test.com?control_code=1234&control_num=42&fname=test&lname=user&addr=123+street&city=hereville&state=NY&zip=99999&gender=0&email=test@test.com"
      end
    end

    context "when the control code is blank" do
      before do
        control_code_determiner.stub(:determine_control_code).and_return("")
      end

      it "raises an error" do
        pending "Pending until Ashish figures out what he wants to do with a blank control code"
        expect { exam_one.schedule_url(crm_connection, crm_case) }.to raise_error(Processing::ExamOne::CompanyNotSupportedError, "This company is not supported. If you believe you received this message in error, please contact support.")
      end
    end
  end
end
