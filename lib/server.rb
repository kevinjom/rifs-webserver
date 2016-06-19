require 'socket'

module RIFS
  class Server
    # The tcp server
    attr_reader :server

    def initialize(port=8088, opts={})
      @server = TCPServer.new port

      trap(:INT) {stop}

      puts "Serving on #{port}"
    end

    def start
      loop do
        sock = server.accept
        Thread.new {handle_request sock}
      end
    end

    def handle_request(sock)
        sock.puts 'Hello world'
        sleep 3
        sock.puts 'Hello world 2'
        sock.close
    end

    def stop
      puts 'Shutting down....'
      server.close
      puts 'Server stopped!'
    end
  end
end
