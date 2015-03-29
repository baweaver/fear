module Functional
  module ActiveModel
    module Conversion
      def to_key
        Option(super)
      end
    end
  end
end
