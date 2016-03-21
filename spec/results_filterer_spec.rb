require 'spec_helper'

describe GoldenRose::ResultsFilterer do
  subject { described_class.new(parsed_plist) }

  describe ".filter!" do
    context "with missing testable summaries" do
      let(:parsed_plist) { {} }

      it "raises error" do
        expect { 
          subject.filter! 
        }.to raise_error(GoldenRose::GeneratingError, "Testable summaries not present.")
      end
    end
  end
end