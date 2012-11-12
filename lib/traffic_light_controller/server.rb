module TrafficLightController
  class Server

    def initialize
      Thread.abort_on_exception = true
      @config = Config.new
      @server = TCPServer.new(config.server.address, config.server.port)
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

    attr_reader :server, :config, :board

    def start_thread_and_do_work
      Thread.start(server.accept) do |client|
        work_with_client(client)
      end
    end

    def work_with_client(client)
      puts "work_with_client"
      process_path(process_request(client))
    rescue => e
      puts "Got #{e.class}: #{e}!"
    ensure
      client.close
    end

    def process_request(client)
      puts "process_request"
      path = nil

      while(line = client.readline) do
        break if line == "\r\n"
        if match = line.match(%r{GET /+(?<path>\w*) HTTP/1\.})
          path = match[:path]
        end
      end

      path
    end

    def process_path(path)
      puts "process_path"
      if config.arduino.lights.has_key?(path)
        change_pins(path)
        client.print "HTTP/1.1 200 OK\r\nContent-type:text/plain\r\n\r\n"
        client.puts path
      else
        client.print "HTTP/1.1 404 Not Found\r\nContent-type:text/plain\r\n\r\n"
        client.puts "The requested path doesn't exist"
      end
    end

    def change_pins(path)
      puts "change_pins"
      init_board
      board.turnOff
      board.setHigh(config.arduino.lights[path]) unless path == "off"
      board.close
    end

    def init_board
      puts "board"
      @board = Arduino.new(config.arduino.port)
    rescue Errno::ENOENT
      STDERR.puts "The port #{config.arduino.port} doesn't exist"
      exit
    rescue ArgumentError
      STDERR.puts "#{config.arduino.port} is not a serial port"
      exit
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
