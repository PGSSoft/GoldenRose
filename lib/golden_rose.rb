require "golden_rose/version"
require "golden_rose/subtest_item"
require "golden_rose/parser"
require "golden_rose/results_filterer"
require "golden_rose/generators/html_format"
require "golden_rose/cli/app"

module GoldenRose
  def self.generate(folder_path, output_path, format: :html)
    parsed_plist = Parser.new(folder_path).parse!
    results      = ResultsFilterer.new(parsed_plist).filter!

    case format
    when :html
      Generators::HtmlFormat.new(results, output_path).output
    else 
      raise GeneratingError, "Format not supported."
    end
  end

  def self.root
    File.dirname(__dir__)
  end

  class GeneratingError < StandardError; end
end
