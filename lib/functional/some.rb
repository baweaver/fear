require 'rtc'

module Functional
  class Some < Option

    # @!attribute get
    #   @return option's value
    typesig('@get: Symbol')
    attr_reader :get

    def initialize(value)
      @get = value
    end

    def empty?
      false
    end

    def ==(other)
      if other.is_a?(Some)
        get == other.get
      else
        false
      end
    end

    def eql?(other)
      if other.is_a?(Some)
        get.eql?(other.get)
      else
        false
      end
    end
  end
end
