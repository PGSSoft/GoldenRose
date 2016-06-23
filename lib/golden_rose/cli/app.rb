require "thor"

module GoldenRose
  module CLI
    class App < Thor
      desc "generate <path_to_folder_or_zip>", "Generate report from a folder"
      method_option :output, type: :string, aliases: "-o"

      def generate(folder_path)
        say("Started formatting report...")
        GoldenRose::generate(folder_path, options[:output])
        say("Report generated in #{options[:output] || Dir.pwd}/index.html", :green)
      rescue GoldenRose::GeneratingError => e
        say(e.message, :yellow)
      rescue StandardError => e
        say("Error during running generator.", :red)
      end
    end
  end
end