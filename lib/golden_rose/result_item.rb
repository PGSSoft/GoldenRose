# This class extends plist elements to check if it should be included in results
# and prepares it for better use in generators

module GoldenRose
  class ResultItem < Hash
    attr_accessor :parent, :failures_count, :error_details, :error_message

    def copy_from(source_item)
      self.name = source_item['Title'] || source_item['TestName']
      self.test_status ||= source_item['TestStatus']
      set_time(source_item)
      set_error_details(source_item)
    end

    def child_collection
      values.select{ |v| v.is_a? Array }
    end

    def has_child?
      child_collection.any?
    end

    def required?
      %w(Tests Subtests ActivitySummaries).include?(type) ||  !!test_status
    end

    def success?
      test_status == "Success"
    end

    def status_css_class
      return unless test_status
      test_status.downcase
    end

    %w(type name test_status time).each do |field_name|
      camelized = field_name.split('_').collect(&:capitalize).join

      define_method(field_name) { self[camelized] }

      define_method("#{field_name}=") do |value|
        self[camelized] = value
      end
    end

    private

    def set_time(source_item)
      items = source_item.select { |k| k == "ActivitySummaries" }.values.first
      return unless items

      counted_time = items.last['FinishTimeInterval'] - items.first['StartTimeInterval']
      self.time = "#{counted_time.round(2)}s"
    end

    def set_error_details(source_item)
      failures = source_item['FailureSummaries']
      return unless failures

      parent.failures_count = failures.count
      failure = failures.first
      self.error_message = "#{failure['Message'].gsub(/\n/, '')}"
      self.error_details = "#{failure['FileName']}:#{failure['LineNumber']}"
    end

    def assertion_failure?
      !!(name =~ /^Assertion Failure/)
    end

    def start_test?
      name == "Start Test"
    end

    def subtests?
      type == "Subtests"
    end
  end
end