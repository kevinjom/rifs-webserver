require 'socket'

module RIFS
  class Server

    # The tcp server
    attr_reader :server

    def initialize(port=8088, opts={})
      @server = TCPServer.new port

      trap(:INT) { stop }
      puts "Serving at port #{port}"
    end

    def start
      loop do
        sock = server.accept
        sock.puts 'Hello world'
        sock.close
      end
    end

    def stop
      puts 'Shutting down...'
      server.close
      puts 'Stoped!'
    end
  end
end
