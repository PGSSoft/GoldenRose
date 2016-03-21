# This class is responsible for filtering results
# for needed fields it and returning structure with ResultItems

module GoldenRose
  class ResultsFilterer
    ALLOWED_FIELDS = %w(Tests Subtests ActivitySummaries SubActivities)
    attr_accessor :parsed_plist, :results

    def initialize(parsed_plist)
      @parsed_plist = parsed_plist
    end

    def filter!
      raise GeneratingError, "Testable summaries not present."  unless testable_summaries
      @results = Results.new(test_details, iterate(testable_summaries).first)
    end

    def testable_summaries
      parsed_plist['TestableSummaries']
    end

    def subtests
      iterate(testable_summaries).first['Tests'].first['Subtests'].first
    end

    def iterate(items, parent = nil)
      collection = items.map do |source_item|
        ResultItem.new.tap do |new_item|
          new_item.parent = parent
          new_item.copy_from(source_item)
          source_item.each do |k, v|
            next unless field_allowed?(k)
            new_item.type = k
            new_item[k] = iterate(v, new_item) if iterate(v, new_item).any?
          end
        end
      end.select(&:required?)
    end

    def test_details
      { 
        name: testable_summaries.first['TestName']
      }
    end

    private

    def field_allowed?(key)
      ALLOWED_FIELDS.include?(key)
    end

    def get_children(hash, keys)
      key = keys.delete_at(0)

      raise GeneratingError, "#{key} not present in plist structure." if hash[key].nil?

      if keys.empty?
        hash[key]
      else
        get_children(hash[key].first, keys)
      end
    end

    class Results < Struct.new(:details, :items); end
  end
end