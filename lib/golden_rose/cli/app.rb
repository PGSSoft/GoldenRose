require "thor"
require "rainbow"

module GoldenRose
  module CLI
    class App < Thor
      desc "generate <path_to_folder_or_zip>", "Generate report from a folder"
      method_option :output, type: :string, aliases: "-o"

      def generate(folder_path)
        puts "Started formatting report..."
        GoldenRose::generate(folder_path, options[:output])
        puts Rainbow("Report generated in #{options[:output] || Dir.pwd}/index.html").green
      rescue GoldenRose::GeneratingError => e
        puts puts Rainbow(e.message).yellow
      rescue StandardError => e
        puts Rainbow("Error during running generator: #{e.message}").red
      end
    end
  end
end