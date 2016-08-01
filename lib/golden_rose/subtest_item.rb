# Used for setting single subtest details

module GoldenRose
  class SubtestItem
    attr_reader :name

    def initialize(source_subtest)
      @name = source_subtest["TestName"]
    end

    def to_h
      hashable_attributes.each_with_object({}) do |field, hash|
        hash[field] = public_send(field) if public_send(field)
      end
    end
  end
end