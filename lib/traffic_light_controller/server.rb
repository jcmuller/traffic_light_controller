module TrafficLightController
  class Server

    def initialize
      begin
        Thread.abort_on_exception = true
        @config = Config.new
        @server = TCPServer.new(config.server.address, config.server.port)
      rescue Errno::EADDRINUSE
        puts "Address in use"
      rescue Errno::EADDRNOTAVAIL, SocketError
        puts "Address not available"
      end
    end

    def work(run_forever = true)
      while(run_forever)
        Thread.start(server.accept) do |client|
          begin
            path = nil

            while(line = client.readline) do
              break if line == "\r\n"
              if match = line.match(%r{GET /+(?<path>\w*) HTTP/1\.})
                path = match[:path]
              end
            end

            if config.arduino.lights.has_key?(path)
              process(path)
              client.print "HTTP/1.1 200 OK\r\nContent-type:text/plain\r\n\r\n"
              client.puts path
            else
              client.print "HTTP/1.1 404 Not Found\r\nContent-type:text/plain\r\n\r\n"
              client.puts "The requested path doesn't exist"
            end
          rescue => e
            puts "Got #{e}!"
          ensure
            client.close
          end
        end
      end
    end

    def process(path)
      board.turnOff
      board.setHigh(config.arduino.lights[path]) unless path == "off"
    end

    private

    attr_reader :server, :config

    def board
      @board ||= Arduino.new(config.arduino.port)
    end
  end
end
