module Functional
  module ActiveRecord
    module Querying
      module ClassMethods
        def take
          Option(super)
        end
      end

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end
    end
  end
end
