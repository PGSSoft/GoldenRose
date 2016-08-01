# Used for setting single subtest details
# It contains collection of child subtests

module GoldenRose
  class ParentItem < SubtestItem
    attr_accessor :subtests

    # Used in html generator
    def node_id
      @node_id ||= "node_#{object_id}"
    end

    def failures_count
      @failures_count ||= failed_subtests? ? failed_subtests.size : nil
    end

    private

    def failed_subtests
      subtests.select { |subtest| subtest[:status] == "failure" }
    end

    def failed_subtests?
      failed_subtests.size > 0 
    end

    def hashable_attributes
      %i(subtests name failures_count node_id)
    end
  end
end