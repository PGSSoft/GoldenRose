# This class is responsible for parsing plist from zip file

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
      archive? ? open_zip! : open_directory!
      raise GeneratingError, "File 'TestSummaries.plist' was not found in the folder." unless @plist_file_path
      @parsed_plist = Plist::parse_xml(@plist_file_path)
      File.delete(@plist_file_path)
      raise GeneratingError, "Could not parse plist correctly." unless parsed_plist

      @parsed_plist
    end

    private

    def open_directory!
      dir = Dir.open(folder_path)
      dir.each do |file|
        @plist_file_path = File.join(folder_path, file) if test_summaries?(file)
      end
    rescue Errno::ENOENT
      raise GeneratingError, "Could not open the folder."
    end

    def open_zip!
      Zip::File.open(folder_path) do |zip_file|
        zip_file.each do |entry|
          file_name = File.basename(entry.name)
          if test_summaries?(file_name)
            uuid = ::SecureRandom.uuid
            @plist_file_path = File.join(GoldenRose::root, "/source_#{uuid}.plist")
            entry.extract(@plist_file_path)
          end
        end
      end
    rescue Zip::Error
      raise GeneratingError, "Could not open the folder."
    end

    def test_summaries?(file_name)
      file_name == "TestSummaries.plist"
    end

    def archive?
      !(folder_path =~ /\.(?:rar|zip|tar.gz)$/).nil?
    end
  end
end