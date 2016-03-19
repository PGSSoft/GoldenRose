#!/usr/bin/env ruby

require 'plist'
require 'haml'
require 'tilt/haml'

class TestsResults
  attr_accessor :file_path, :parsed_plist

  def initialize(file_path)
    @file_path = file_path
    parse
  end

  def filtered
    { 
      "Title" => "TestableSummaries",
      "TestableSummaries" => iterate(testable_summaries) 
    }
  end

  def testable_summaries
    parsed_plist["TestableSummaries"]
  end

  def iterate(items, parent_type: nil)
    items.map do |item|
      h = {}
      if %w(ActivitySummaries SubActivities).include?(parent_type)
        h["Title"] = item["Title"]
      end
      if parent_type == "Subtests" && item.keys.include?("ActivitySummaries")
        h["TestStatus"] = item["TestStatus"]
      end
      item.each do |k, v|
        case k
        when "Tests"
          h["Type"] = k
          h["TestName"] = item["TestName"]
          h[k] = iterate(v)
        when "Subtests"
          h["Type"] = k
          h["TestName"] = item["TestName"]
          h["Subtests"] = iterate(v, parent_type: k)
        when "ActivitySummaries"
          h["Type"] = k
          h["TestName"] = item["TestName"]
          h["ActivitySummaries"] = iterate(v, parent_type: k)
        when "SubActivities"
          h["Type"] = k
          h["Title"] = item["Title"]
          h["SubActivities"] = iterate(v, parent_type: k)
        end
      end
      h
    end
  end

  private

  def parse
    @parsed_plist = Plist::parse_xml(file_path)
  end
end

class HtmlGenerator
  TAB_SIZE = 2
  attr_accessor :file, :haml_list, :hash_to_convert

  def initialize(hash_to_convert)
    @hash_to_convert = hash_to_convert
    @haml_list = ""
  end

  def output
    @file = File.new("output/index.html", "w+")
    to_haml_list(hash_to_convert)
    template = Tilt::HamlTemplate.new('templates/header.haml')
    file.puts template.render { Haml::Engine.new(haml_list).render }
    file.close
  end

  def to_haml_list(object, indent = 0)
    case object
    when Array
      object.each do |item|
        to_haml_list(item, indent + 1)
      end
    when Hash
      new_line(indent, :ul)
      child = object.values.select{ |v| v.is_a? Array }
      if child
        new_line(indent + 1, :li)
        new_line(indent + 2, :a, object['TestName'] || object['Title'])
        to_haml_list(child, indent)
      else
        new_line(indent + 1, :li)
        new_line(indent + 2, :a, object['TestName'] || object['Title'])
      end
    when String
      new_line(indent + 1, :li, object['Title'])
    end
  end

  def new_line(indent_level, tag, content = nil)
    indent_space = " " * indent_level * TAB_SIZE
    haml_list << "#{indent_space}%#{tag} #{content}\n"
  end
end

results = TestsResults.new("sample.plist")
generator = HtmlGenerator.new(results.filtered)

generator.output