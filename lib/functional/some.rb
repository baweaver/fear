module Functional
  class Some
    include Option
    include Contracts

    # @!attribute get
    #   @return option's value
    attr_reader :get

    def initialize(value)
      @get = value
    end

    Contract Contracts::None => Bool
    def empty?
      false
    end

    Contract Any => Bool
    def ==(other)
      if other.is_a?(Some)
        get == other.get
      else
        false
      end
    end

    Contract Any => Bool
    def eql?(other)
      if other.is_a?(Some)
        get.eql?(other.get)
      else
        false
      end
    end
  end
end
