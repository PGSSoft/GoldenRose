require 'spec_helper'

describe GoldenRose::ParentItem do
  subject { described_class.new(source_subtest) }
  let(:source_subtest) { { "TestName" => "Some parent test name" } }
  let(:subtests) do
    [
      { name: "subtest01Name()", time: "7.91s", status: "success" },
      { name: "subtest02Name()", time: "2.00s", status: "failure" },
      { name: "subtest03Name()", time: "5.93s", status: "success" },
      { name: "subtest04Name()", time: "7.56s", status: "failure" }
    ]
  end
  before do
    subject.subtests = subtests
  end

  it "has name from source subtest" do
    expect(subject.name).to eq("Some parent test name")
  end

  it "calculates failures count" do
    expect(subject.failures_count).to eq(2)
  end
end