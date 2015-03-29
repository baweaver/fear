module Functional
  module ActiveRecord
    module Relation
      module ClassMethods
        def take
          Option(super)
        end

        def find(*args)
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

