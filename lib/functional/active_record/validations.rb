module Functional
  module ActiveRecord
    module Validations
      def save!(*)
        Try { super }
      end

      def validate!(*)
        Try { super }
      end
    end
  end
end
