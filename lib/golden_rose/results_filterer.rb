# This class is responsible for filtering results
# to include only subtests with needed details

module GoldenRose
  class ResultsFilterer
    attr_accessor :parsed_plist, :results

    def initialize(parsed_plist)
      @parsed_plist = parsed_plist
    end

    def filter!
      raise GeneratingError, "Testable summaries not present." unless testable_summaries
      raise GeneratingError, "Tests not present." unless tests
      @results = Results.new(test_details, items)
    end

    private

    def iterate_subtests(items)
      items.map.with_index do |subtest, i|
        child_subtests = subtest["Subtests"]
        next if child_subtests && child_subtests.empty?

        SubtestItem.new.tap do |item|
          item.subtest = subtest
          item[:subtests] = iterate_subtests(child_subtests) if child_subtests
          item.set_details
        end
      end.reject(&:nil?)
    end

    def items
      compact_results(iterate_subtests(tests)).flatten.compact
    end

    def compact_results(items)
      items.map do |subtest|
        subtests = subtest[:subtests]
        if subtests.size > 1
          subtests
        elsif subtests.size == 1
          compact_results(subtests)
        end
      end
    end

    def test_details
      { 
        name: testable_summaries.first['TestName']
      }
    end

    def testable_summaries
      parsed_plist['TestableSummaries']
    end

    def tests
      testable_summaries.first['Tests']
    end

    class Results < Struct.new(:details, :items); end
  end
end