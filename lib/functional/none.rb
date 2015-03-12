module Functional
  class None
    include Option
    include Contracts

    def empty?
      true
    end

    # @raise [NoMethodError]
    #
    def get
      fail NoMethodError, 'None#get'
    end

    Contract Any => Bool
    def ==(other)
      other.is_a?(None)
    end

    Contract Any => Bool
    def eql?(other)
      other.is_a?(None)
    end
  end
end
