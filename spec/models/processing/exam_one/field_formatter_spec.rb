require File.expand_path("app/models/processing/exam_one/field_formatter")

class TestClass
  include Processing::ExamOne::FieldFormatter
end

describe TestClass do
  let(:test_class) { TestClass.new }

  describe "#format_field" do
    context "with only 1 argument" do
      it "outputs spaces" do
        test_class.format_field(10).should == "          "
      end
    end

    context "with 2 arguments" do
      it "left justifies the string" do
        test_class.format_field(10, "erik").should == "erik      "
      end

      it "replaces new lines with nothing" do
        test_class.format_field(10, "erik\n").should == "erik      "
      end

      it "leaves in erroneous characters" do
        test_class.format_field(10, "(er - ik)").should == "(er - ik) "
      end
    end

    context "with 3 arguments" do
      it "strips out erroneous characters" do
        test_class.format_field(10, "(er - ik)", true).should == "erik      "
      end
    end
  end
end
