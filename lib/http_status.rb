# frozen_string_literal: true

require 'socket'

module RIFS
  class HttpStatus
     attr_reader :code, :phrase

     def initialize(code, phrase=nil)
       @code = code
       @phrase = phrase || StatusCodes[code]
     end

    StatusCodes = {
      200 => 'OK',
      201 => 'Created'
    }
  end
end

