require 'spec_helper'

describe GoldenRose::ResultsFilterer do
  subject { described_class.new(parsed_plist) }

  describe ".filter!" do
    before do
      allow_any_instance_of(GoldenRose::ParentItem).to receive(:node_id).and_return("node_123")
    end

    context "with missing testable summaries" do
      let(:parsed_plist) { {} }

      it "raises error" do
        expect { 
          subject.filter! 
        }.to raise_error(GoldenRose::GeneratingError, "Testable summaries not present.")
      end
    end

    context "with correct parsed plist" do
      let(:parsed_plist) { plist_attrs }

      it "sets correct results" do
        subject.filter!
        expect(subject.results.details.name).to eq("Sample Test iPhone")
        expect(subject.results.items).to eq(filtered_results)
      end
    end
  end

  private

  def plist_attrs
    {
      "FormatVersion" => "1.1", 
      "TestableSummaries" => [
        {
          "ProjectPath" => "sampletest.xcodeproj", 
          "TargetName" => "Sample Test iPhone", 
          "TestName" => "Sample Test iPhone",
          "Tests" => [
            {
              "Subtests" => [
                {
                  "Subtests" => [],
                  "TestIdentifier" => "Utils.framework",
                  "TestName" => "Utils.framework"
                },
                {
                  "Subtests" => [
                    {
                      "Subtests" => [
                        {
                          "ActivitySummaries" => [
                            {
                              "FinishTimeInterval" => 85.679846, 
                              "StartTimeInterval" => 85.679387, 
                              "Title" => "Start Test", 
                              "UUID" => "38D155C5-CCDD-4D9F-9D28-D838314EAD44"
                            },
                            {
                              "FinishTimeInterval" => 93.587023, 
                              "StartTimeInterval" => 93.586658, 
                              "Title" => "Tear Down", 
                              "UUID" => "5A842EE6-CCDD-4D9F-9D28-D838314EAD44"
                            }
                          ], 
                          "TestIdentifier" => "TestsExample1/subtest01Name()",
                          "TestName" => "subtest01Name()",
                          "TestStatus" => "Success",
                          "TestSummaryGUID" => "ABCD1234-AABB-4D9F-9D28-D838314EAD44"
                        }
                      ],
                      "TestIdentifier" => "TestsExample1", 
                      "TestName" => "TestsExample1"
                    },
                    {
                      "Subtests" => [
                        {
                          "ActivitySummaries" => [
                            {
                              "FinishTimeInterval" => 85.679846, 
                              "StartTimeInterval" => 85.679387, 
                              "Title" => "Start Test", 
                              "UUID" => "38D155C5-CCDD-4D9F-9D28-D838314EAD44"
                            },
                            {
                              "FinishTimeInterval" => 93.587023, 
                              "StartTimeInterval" => 93.586658, 
                              "Title" => "Tear Down", 
                              "UUID" => "5A842EE6-CCDD-4D9F-9D28-D838314EAD44"
                            }
                          ],
                          "FailureSummaries" => [
                            {
                              "FileName" => "/Users/Documents/TestFile.swift", 
                              "LineNumber" => 76, 
                              "Message" => "Failed to find Button after 10.0 seconds.", 
                              "PerformanceFailure" => false
                            },
                            {
                              "FileName" => "/Users/Documents/TestFile.swift", 
                              "LineNumber" => 49, 
                              "Message" => "Asynchronous wait failed: Exceeded timeout of 10 seconds.", 
                              "PerformanceFailure" => false
                            }
                          ],
                          "TestIdentifier" => "TestsExample2/subtest02Name()",
                          "TestName" => "subtest02Name()",
                          "TestStatus" => "Failure",
                          "TestSummaryGUID" => "ABCD1234-CCDD-4D9F-9D28-D838314EAD44"
                        },
                        {
                          "ActivitySummaries" => [
                            {
                              "FinishTimeInterval" => 85.679846, 
                              "StartTimeInterval" => 85.679387, 
                              "Title" => "Start Test", 
                              "UUID" => "38D155C5-CCDD-4D9F-9D28-D838314EAD44"
                            },
                            {
                              "FinishTimeInterval" => 93.587023, 
                              "StartTimeInterval" => 93.586658, 
                              "Title" => "Tear Down", 
                              "UUID" => "5A842EE6-CCDD-4D9F-9D28-D838314EAD44"
                            }
                          ],
                          "TestIdentifier" => "TestsExample2/subtest03Name()",
                          "TestName" => "subtest03Name()",
                          "TestStatus" => "Success",
                          "TestSummaryGUID" => "ABCD1234-EEFF-4D9F-9D28-D838314EAD44"
                        }
                      ],
                      "TestIdentifier" => "TestsExample2", 
                      "TestName" => "TestsExample2"
                    }
                  ],
                  "TestIdentifier" => "Sample Test iPhone.xctest",
                  "TestName" => "Sample Test iPhone.xctest"
                }
              ],
              "TestIdentifier" => "Selected tests", 
              "TestName" => "Selected tests"
            }
          ]
        }
      ]
    }
  end

  def filtered_results
    [
      {
        subtests: [
          {
            name: "subtest01Name()",
            time: "7.91s",
            status: "success"
          }
        ],
        name: "TestsExample1",
        node_id: "node_123"
      },
      {
        subtests: [
          {
            name: "subtest02Name()",
            time: "7.91s",
            failures: [
              {
                message: "Failed to find Button after 10.0 seconds.",
                file_name: "/Users/Documents/TestFile.swift",
                line_number: 76
              },
              {
                message: "Asynchronous wait failed: Exceeded timeout of 10 seconds.",
                file_name: "/Users/Documents/TestFile.swift",
                line_number: 49
              }
            ],
            status: "failure"
          },
          {
            name: "subtest03Name()",
            time: "7.91s",
            status: "success"
          }
        ],
        name: "TestsExample2",
        failures_count: 1,
        node_id: "node_123"
      }
    ]
  end
end