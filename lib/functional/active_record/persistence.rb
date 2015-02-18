module Functional
  module ActiveRecord
    module Persistence
      def save!(*)
        Try { super }
      end

      def touch(*)
        Try { super }
      end

      def update!(*)
        Try { super }
      end

      def update_columns(*)
        Try { super }
      end
    end
  end
end
