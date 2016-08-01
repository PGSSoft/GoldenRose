# Used for setting single subtest details
# It represents last level of tests

module GoldenRose
  class ChildItem < SubtestItem
    attr_reader :status, :time, :failures

    def initialize(source_subtest)
      @status = source_subtest["TestStatus"].downcase
      set_time(source_subtest)
      set_failures(source_subtest)

      super
    end

    private

    def set_time(source_subtest)
      last_time  = source_subtest["ActivitySummaries"].last["FinishTimeInterval"]
      first_time = source_subtest["ActivitySummaries"].first["StartTimeInterval"]

      return unless last_time && first_time

      counted_time = last_time - first_time
      @time = "#{counted_time.round(2)}s"
    end

    def set_failures(source_subtest)
      return unless source_subtest["FailureSummaries"]
      @failures = source_subtest["FailureSummaries"].map do |failure|
        {
          message: failure["Message"],
          file_name: failure["FileName"],
          line_number: failure["LineNumber"]
        }
      end
    end

    def hashable_attributes
      %i(name status time failures)
    end
  end
end