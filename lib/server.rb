# frozen_string_literal: true

require 'socket'
require_relative 'response'
require_relative 'http_status'

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
        response = HttpResponse.new sock
        response.status = HttpStatus.new 201
        response.body = 'hello world'
        sock.puts 'wtf'
        sock.close unless sock.closed?
    rescue => e
      puts e.inspect
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
