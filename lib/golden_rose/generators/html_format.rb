# Generating html file from results using haml

require "haml"
require "tilt/haml"
require "pathname"

module GoldenRose
  module Generators
    class HtmlFormat
      def initialize(results, output_path = nil)
        @details     = results.details
        @items       = results.items
        @output_path = output_path || ""
      end

      def output
        file_path = Pathname(@output_path) + "index.html"
        file = File.new(file_path, "w+")
        template_path = File.join(GoldenRose::root, "/lib/golden_rose/templates/index.haml")
        template = Tilt::HamlTemplate.new(template_path)
        file.puts template.render(self)
        file.close
      end
    end
  end
end