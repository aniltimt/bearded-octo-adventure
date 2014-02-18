require File.expand_path("app/models/processing/exam_one/total_generator")

module Processing
  class ExamOne
    describe TotalGenerator do
      let(:total_generator) { TotalGenerator.new }

      describe "#generate" do
        it "generates a string" do
          total_generator.generate.should == "TOTL1         10                                                                                                                    "
        end
      end
    end
  end
end
