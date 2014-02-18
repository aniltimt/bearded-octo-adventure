require "spec_helper"

describe Processing::ExamOne::Or01Parser do
  let(:or01_parser) { Processing::ExamOne::Or01Parser.new }

  describe "#parse_info" do
    context "when the policy exists" do
      let(:connection) { FactoryGirl.create(:crm_connection) }
      let(:crm_case) { FactoryGirl.create(:crm_case, crm_connection: connection) }
      let(:info) { "OR01\nPI01                #{crm_case.id}\nST                      1234      this is the status lol                                                       20130320" }

      it "creates a status" do
        or01_parser.parse_info(info)
        status = Processing::ExamOne::Status.last
        status.description.should == "this is the status lol"
        status.completed_at.should == Date.new(2013, 3, 20)
        status.connection_id.should == crm_case.crm_connection.id
        status.exam_one_status_id.should == 1234
      end

      context "when there are duplicate statuses" do
        let(:info) { "OR01\nPI01                #{crm_case.id}\nST                      1234      this is the status lol                                                       20130320\nOR01\nPI01                #{crm_case.id}\nST                      1234      this is the status lol                                                       20130320" }

        it "does not create duplicates" do
          count = Processing::ExamOne::Status.count
          or01_parser.parse_info(info)
          Processing::ExamOne::Status.count.should == count + 1
        end
      end

      context "when there are multiple statuses" do
        let(:info) { "OR01\nPI01                #{crm_case.id}\nST                      1234      this is the status lol                                                       20130320\nOR01\nPI01                #{crm_case.id}\nST                      1234      what is the status lol                                                       20130320" }

        it "creates two statuses" do
          count = Processing::ExamOne::Status.count
          or01_parser.parse_info(info)
          Processing::ExamOne::Status.count.should == count + 2
        end
      end

      context "when there are multiple statuses in the same OR01" do
        let(:info) { "OR01\nPI01                #{crm_case.id}\nST                      1234      this is the status lol                                                       20130320\nST                      1234      what is the status lol                                                       20130320" }

        it "creates a status" do
          count = Processing::ExamOne::Status.count
          or01_parser.parse_info(info)
          Processing::ExamOne::Status.count.should == count + 1
          status = Processing::ExamOne::Status.last
          status.description.should == "this is the status lolwhat is the status lol"
          status.completed_at.should == Date.new(2013, 3, 20)
          status.connection_id.should == crm_case.crm_connection.id
          status.exam_one_status_id.should == 1234
        end
      end
    end

    context "when the policy number is blank" do
      let(:info) { "OR01\nPI01                 " }

      it "does not create a status" do
        count = Processing::ExamOne::Status.count
        or01_parser.parse_info(info)
        Processing::ExamOne::Status.count.should == count
      end
    end

    context "when the policy does not exist with the given policy_number" do
      let(:info) { "OR01\nPI01                lol " }

      it "does not create a status" do
        count = Processing::ExamOne::Status.count
        or01_parser.parse_info(info)
        Processing::ExamOne::Status.count.should == count
      end
    end
  end
end
