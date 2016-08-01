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
      @results = Results.new(execution_details, items)
    end

    private

    def iterate_subtests(items)
      items.map do |subtest|
        child_subtests = subtest["Subtests"]
        next if child_subtests && child_subtests.empty?

        if child_subtests
          ParentItem.new(subtest).tap do |item|
            item.subtests = iterate_subtests(child_subtests)
          end.to_h
        else
          ChildItem.new(subtest).to_h
        end
      end.compact
    end

    def items
      @items ||= compact_results(iterate_subtests(tests))
    end

    # This method simplify results structure,
    # it sets only one level of nesting
    # by leaving parents only with collection as child
    def compact_results(items)
      items.map do |subtest|
        subtests = subtest[:subtests]
        if subtests.size > 1
          subtests
        elsif subtests.size == 1
          compact_results(subtests)
        end
      end.flatten.compact
    end

    def execution_details
      ExecutionDetails.new(parsed_plist, items)
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