module Functional
  module ActiveRecord
    module Validations
      def validate!(*)
        Try { super }
      end
    end
  end
end
