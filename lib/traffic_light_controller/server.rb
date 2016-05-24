require "piface"
require "socket"

module TrafficLightController
  class Server

    class << self
      def run
        server = Server.new
        server.work
      end
    end

    def initialize(config = Config.new)
      Thread.abort_on_exception = true
      @config = config
      @server = TCPServer.new(config.server.address, config.server.port)
      @current_path = ""
    rescue Errno::EADDRINUSE
      address_in_use_error(config.server)
    rescue Errno::EADDRNOTAVAIL, SocketError
      address_not_available_error(config.server.address)
    end

    def work
      while(true)
        start_thread_and_do_work
      end
    end

    private

    attr_reader :server, :config, :current_path

    def start_thread_and_do_work
      Thread.start(server.accept) do |request|
        accept_request(request)
      end
    end

    def accept_request(request)
      process_request(request)
    rescue => e
      STDERR.puts "Got #{e.class}: #{e}!

#{e.backtrace.join($/)}"
    ensure
      request.close
    end

    def process_request(request)
      path = path_from_request(request)

      if config.piface.key?(path) || (path == "off")
        if path != current_path
          @current_path = path
          change_pins(path)
          respond_200(request, path)
        else
          respond_304(request, path)
        end
      else
        respond_404(request, path)
      end
    end

    def path_from_request(request)
      path = ""
      while(line = request.readline) do
        break if line == "\r\n"
        if match = line.match(%r{GET /+(?<path>\w*) HTTP/1\.})
          path = match[:path]
        end
      end

      path
    end

    def change_pins(path)
      cfg = config.piface[path]

      Piface.init
      Piface.write(cfg.pin, Piface::HIGH)

      if cfg.reset_after_delay?
        Thread.start do
          sleep cfg.reset_after_delay
          Piface.init
        end
      end
    end

    def respond_200(request, path)
      request.print "HTTP/1.1 200 OK\r\nContent-type:text/plain\r\n\r\n"
      request.puts path
    end

    def respond_304(request, path)
      request.puts "HTTP/1.1 304 Not Modified\r\nContent-type:text/plain\r\n\r\n"
    end

    def respond_404(request, path)
      request.print "HTTP/1.1 404 Not Found\r\nContent-type:text/plain\r\n\r\n"
      request.puts "The requested path doesn't exist"
    end

    # ERRORS
    def address_in_use_error(server)
      STDERR.puts <<-EOT
There appears that another instance is running, or another process
is listening on the same port (#{server.address}:#{server.port})

      EOT
      exit
    end

    def address_not_available_error(address)
      STDERR.puts <<-EOT
The address configured is not available (#{address})

      EOT
      exit
    end
  end
end
