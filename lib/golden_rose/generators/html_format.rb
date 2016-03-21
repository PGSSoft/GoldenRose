# Generating html file from results using haml

require "haml"
require "tilt/haml"
require "pathname"

module GoldenRose
  module Generators
    class HtmlFormat
      TAB_SIZE = 2

      def initialize(results, output_path = nil)
        @details     = results.details
        @items       = results.items
        @output_path = output_path || ""
        @list = ""
        @current_node_number = 0
      end

      def output
        file_path = Pathname(@output_path) + "index.html"
        file = File.new(file_path, "w+")
        to_list(@items)
        @rendered_list = Haml::Engine.new(@list).render
        template_path = File.join(GoldenRose::root, "/lib/golden_rose/templates/index.haml")
        template = Tilt::HamlTemplate.new(template_path)
        file.puts template.render(self)
        file.close
      end

      private

      def to_list(element, indent = 0)
        @current_indent = indent
        @current_node_number += 1
        case element
        when Array
          element.each { |item| to_list(item, indent + 1) }
        when ResultItem
          add_tag(:li)
          if element.has_child?
            add_tag(:label, element.name, indent: 1, for: node_id, class: element.status_css_class)
            add_tag(:span, "#{element.time}", indent: 2, class: "time") if element.time
            add_tag(:span, "Failures: #{element.failures_count}", indent: 2, class: "failures-count") if element.failures_count
            add_tag(:input, indent: 1, id: node_id, type: "checkbox")
            add_tag(:ol, indent: 1)

            to_list(element.child_collection, indent)
          else
            add_tag(:span, element.name, indent: 1, class: "#{element.status_css_class} last-node")
            add_tag(:span, "#{element.time}", indent: 2, class: "time") if element.time
            add_tag(:div, element.error_message, indent: 2, class: "error-details")
            add_tag(:div, element.error_details, indent: 2, escaped: true, class: "error-details")
          end
        end
      end

      def node_id
        "node#{@current_node_number}"
      end

      def add_tag(tag, content = nil, indent: 0, escaped: false, **options)
        escaped_content = CGI.escapeHTML(content).gsub(/\n/, '') if content
        @list << "#{indent_space(indent)}%#{tag}#{options}\n"
        @list << "#{indent_space(indent + 1)}=\"#{escaped_content}\"\n"
      end

      def indent_space(indent)
        " " * (@current_indent + indent) * TAB_SIZE
      end
    end
  end
end