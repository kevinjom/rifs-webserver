# frozen_string_literal: true

require 'socket'

module RIFS
  class Server
    SERVER_NAME = 'rifs-webserver'

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
        write_status_line(sock)
        write_headers(sock)
        write_body(sock)
        sock.close
    end

    def write_status_line(sock)
      sock.puts 'HTTP/1.1 200 OK'
    end

    def write_body(sock)
        sock.puts 'Hello world'
        sock.puts 'Hello world 2'
    end

    def write_headers(sock)
      sock.puts "Server: #{SERVER_NAME}"
      sock.puts ''
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
