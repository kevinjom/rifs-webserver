# frozen_string_literal: true

require 'socket'

module RIFS
  class HttpRequest
    attr_reader :method

    attr_reader :headers
    attr_reader :body

    attr_reader :path
    attr_reader :params


    def self.read(socket)
    end
  end
end

