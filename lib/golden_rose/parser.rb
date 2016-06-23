# This class is responsible for parsing plist
# from zip file or folder

require "plist"
require "zip"
require "securerandom"

module GoldenRose
  class Parser
    attr_accessor :parsed_plist, :folder_path

    def initialize(folder_path)
      @folder_path = folder_path
    end

    def parse!
      archive? ? open_zip : open_directory
      raise GeneratingError, "File 'TestSummaries.plist' was not found in the folder." unless @plist_file_path
      @parsed_plist = Plist::parse_xml(@plist_file_path)
      File.delete(@plist_file_path) if archive?
      raise GeneratingError, "Could not parse plist correctly." unless parsed_plist
      parsed_plist

    rescue Zip::Error, Errno::ENOENT
      raise GeneratingError, "Could not open the folder."
    end

    private

    def open_directory
      dir = Dir.open(folder_path)
      file = dir.find { |file| test_summaries?(file) }
      @plist_file_path = File.join(folder_path, file)
    end

    def open_zip
      Zip::File.open(folder_path) do |zip_file|
        entry = zip_file.find do |entry|
          file_name = File.basename(entry.name)
          test_summaries?(file_name)
        end
        if entry
          uuid = ::SecureRandom.uuid
          @plist_file_path = File.join(GoldenRose::root, "/source_#{uuid}.plist")
          entry.extract(@plist_file_path)
        end
      end
    end

    def test_summaries?(file_name)
      file_name == "TestSummaries.plist"
    end

    def archive?
      !(folder_path =~ /\.(?:rar|zip|tar.gz)$/).nil?
    end
  end
end