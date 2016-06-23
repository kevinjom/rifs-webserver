# frozen_string_literal: true

require 'socket'
require_relative 'http_status'

module RIFS
  class HttpResponse
    SERVER_NAME = 'rifs-webserver'

    attr_reader :socket

    attr_accessor :status
    attr_reader :headers
    attr_accessor :body

    def initialize(socket)
      @socket = socket

      @status = HttpStatus.new 200

      @headers = {}
      @headers[:Server] = SERVER_NAME
    end

    def write
        write_status_line
        write_headers
        write_body
    end

    def add_header(name, value)
      header[name] = value
    end

    def write_status_line
      line = "HTTP/1.1 #{status.code} #{status.phrase}"
      socket.puts line
    end

    def write_body
      socket.puts body
    end

    def write_headers
      headers_content = headers.map {|name, value| "#{name}: #{value}"}.join '\r\n '
      socket.puts headers_content
      socket.puts ''
    end
  end
end

