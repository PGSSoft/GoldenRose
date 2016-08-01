require 'spec_helper'

describe GoldenRose::ChildItem do
  subject { described_class.new(source_subtest) }
  let(:source_subtest) do
    {
      "ActivitySummaries" => [
        {
          "FinishTimeInterval" => 5.0082, 
          "StartTimeInterval" => 5.0000, 
          "Title" => "Start Test"
        },
        {
          "FinishTimeInterval" => 5.9000, 
          "StartTimeInterval" => 5.0082, 
          "Title" => "Click button"
        },
        {
          "FinishTimeInterval" => 6.1070, 
          "StartTimeInterval" => 5.9000, 
          "Title" => "Tear Down"
        }
      ],
      "FailureSummaries" => [
        {
          "FileName" => "/Users/Documents/TestFile.swift", 
          "LineNumber" => 76, 
          "Message" => "Failed to find Button after 10.0 seconds."
        },
        {
          "FileName" => "/Users/Documents/TestFile.swift", 
          "LineNumber" => 49, 
          "Message" => "Asynchronous wait failed: Exceeded timeout of 10 seconds."
        }
      ],
      "TestName" => "subtest01Name()",
      "TestStatus" => "Failure"
    }
  end

  it "has name from source subtest" do
    expect(subject.name).to eq("subtest01Name()")
  end

  it "calculates and rounds time" do
    expect(subject.time).to eq("1.11s")
  end

  it "sets failures details" do
    expect(subject.failures.first[:file_name]).to eq("/Users/Documents/TestFile.swift")
    expect(subject.failures.first[:line_number]).to eq(76)
    expect(subject.failures.first[:message]).to eq("Failed to find Button after 10.0 seconds.")

    expect(subject.failures.last[:file_name]).to eq("/Users/Documents/TestFile.swift")
    expect(subject.failures.last[:line_number]).to eq(49)
    expect(subject.failures.last[:message]).to eq("Asynchronous wait failed: Exceeded timeout of 10 seconds.")
  end
end