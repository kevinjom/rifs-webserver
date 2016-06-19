require 'socket'

module RIFS
  class Server
    # The tcp server
    attr_reader :server

    # The status of the server
    attr_accessor :status

    def initialize(port=8088, opts={})
      @server = TCPServer.new port

      trap(:INT) {stop}

      self.status = :NEW
      puts "Serving on #{port}"
    end

    def start
      self.status = :RUNNING
      loop do
        break unless running?
        sock = server.accept
        Thread.new {handle_request sock}
      end
    rescue Errno::EBADF, Errno::ENOTSOCK, IOError => ex
    end

    def running?
      status == :RUNNING
    end

    def handle_request(sock)
        sock.puts 'Hello world'
        sleep 3
        sock.puts 'Hello world 2'
        sock.close
    end

    def stop
      status = :SHUTTING_DOWN
      puts 'Shutting down....'
      server.close
      status = :STOPPED
      puts 'Server stopped!'
    end
  end
end
