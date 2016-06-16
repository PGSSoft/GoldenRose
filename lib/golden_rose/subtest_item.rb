# Used for setting single subtest details

module GoldenRose
  class SubtestItem < Hash
    attr_accessor :subtest

    def set_details
      self[:name] = subtest["TestName"]
      child_subtests ? set_parent_details : set_child_details
    end

    private

    def set_parent_details
      return if has_child_subtests?

      self[:failures_count] = failed_subtests.size if failed_subtests?
      self[:node_id] = "node_#{object_id}"
    end

    def set_child_details
      set_time
      set_failures if subtest["FailureSummaries"]
      self[:status] = subtest["TestStatus"].downcase
    end

    def set_time
      last_time  = subtest["ActivitySummaries"].last["FinishTimeInterval"]
      first_time = subtest["ActivitySummaries"].first["StartTimeInterval"]

      return unless last_time && first_time

      counted_time = last_time - first_time
      self[:time]  = "#{counted_time.round(2)}s"
    end

    def set_failures
      self[:failures] = subtest["FailureSummaries"].map do |failure|
        {
          message: failure["Message"],
          file_name: failure["FileName"],
          line_number: failure["LineNumber"]
        }
      end
    end

    def child_subtests
      subtest["Subtests"]
    end

    def has_child_subtests?
      child_subtests.any? { |subtest| subtest.include?("Subtests") }
    end

    def failed_subtests
      self[:subtests].select { |subtest| subtest[:status] == "failure" }
    end

    def failed_subtests?
      failed_subtests.size > 0
    end
  end
end