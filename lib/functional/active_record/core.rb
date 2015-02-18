module Functional
  module ActiveRecord
    module Core
      def find(*)
        Try { super }
      end

      def find_by(*)
        Option(super)
      end

      def find_by!(*)
        Try do
          find_by(*args).get_or_else do
            raise RecordNotFound.new("Couldn't find #{name}")
          end
        end
      end
    end
  end
end
