require "spec_helper"
require "rake"
load "#{Rails.root}/Rakefile"

describe "exam_one:get_statuses" do
  let(:exam_one) { fire_double("Processing::ExamOne") }

  before do
    Processing::ExamOne.stub(:new).and_return(exam_one)
    exam_one.stub(:get_statuses)
  end

  it "gets statuses" do
    exam_one.should_receive(:get_statuses)
    Rake::Task["exam_one:get_statuses"].invoke
  end
end
