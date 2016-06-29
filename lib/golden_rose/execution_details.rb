module GoldenRose
  class ExecutionDetails
    def initialize(parsed_plist, items)
      @parsed_plist = parsed_plist
      @items = items
    end

    def name
      @parsed_plist["TestableSummaries"].first['TestName']
    end

    def total_time
      @items.reduce(0) do |time, item|
        subtests_time = item[:subtests].reduce(0) do |time, item|
          time + item[:time].to_f
        end
        time + subtests_time
      end.round
    end

    def failures_count
      @items.reduce(0) { |count, item| count + item[:failures_count].to_i }
    end

    def total_tests_count
      @items.reduce(0) { |count, item| count + item[:subtests].count }
    end

    def passing_count
      total_tests_count - failures_count
    end

    def model_name
      @parsed_plist["RunDestination"]["TargetDevice"]["ModelName"]
    end

    def os_version
      @parsed_plist["RunDestination"]["TargetDevice"]["OperatingSystemVersion"]
    end
  end
end