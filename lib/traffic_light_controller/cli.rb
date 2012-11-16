require 'command_line_helper'

module TrafficLightController
  class CLI
    include CommandLineHelper::HelpText

    class << self
      def run
        change_program_name
        cli = self.new
        cli.process_command_line_options
        cli.run
      end
    end

    def initialize
      @server = Server.new
    end

    def process_command_line_options
      GetoptLong.new(*options_possible).each do |opt, arg|
        case opt
        when '--help'
          show_help_and_exit
        when '--version'
          show_version_info_and_exit
        end
      end
    end

    def run
      server.work
    end

    private

    attr_reader :server

    def self.change_program_name
      $0 = File.basename($0) << " (#{VERSION})"
    end

    def options_possible
     [
        ['--help',    '-h', GetoptLong::NO_ARGUMENT],
        ['--version', '-V', GetoptLong::NO_ARGUMENT],
      ]
    end

    def show_help_and_exit
      STDOUT.puts help_info
      exit
    end

    def show_version_info_and_exit
      STDOUT.puts version_info
      exit
    end

    def version_info
      <<-EOV
#{program_name}
https://github.com/jcmuller/traffic_light_controller
(c) 2012 Juan C. Muller
      EOV
    end
  end
end
