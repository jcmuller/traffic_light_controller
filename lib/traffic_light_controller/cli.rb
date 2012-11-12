module TrafficLightController
  class CLI
    class << self
      def run
        cli = self.new
        cli.process_command_line_options
        cli.run
      end
    end

    def initialize
      @server = Server.new
    end

    def process_command_line_options
      @options = {}

      GetoptLong.new(*options_possible).each do |opt, arg|
        case opt
        when '--help'
          show_help_and_exit
        when '--version'
          puts version_info
          exit
        end
      end
    end

    def run
      server.work
    end

    private

    attr_reader :server

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

    def help_info
      <<-EOH
Usage: #{prog_name} [options]
  #{short_hand_options}

  Options:
#{option_details}
#{version_info}
      EOH
    end

    def prog_name
      File.basename($0)
    end

    def short_hand_options
      "[#{options_possible.map{ |o| short_hand_option(o)}.join('], [')}]"
    end

    def short_hand_option(option)
      if option[2] == GetoptLong::REQUIRED_ARGUMENT
        [option[0], option[1]].join('|') << " argument"
      else
        [option[0], option[1]].join('|')
      end
    end

    def option_details
      <<-EOO
#{options_possible.map{ |o| expand_option(o) }.join("\n")}
      EOO
    end

    def version_info
      <<-EOV
traffic_light_controller (#{version_number})
https://github.com/jcmuller/traffic_light_controller
(c) 2012 Juan C. Muller
      EOV
    end

    def version_number
      VERSION
    end

    def longest_width
      @max_width ||= options_possible.map{ |o| o[0] }.max{ |a, b| a.length <=> b.length }.length
    end

    def expand_option(option)
      sprintf("    %-#{longest_width + 6}s %s", option.first(2).join(', '), option[3])
    end
  end
end
