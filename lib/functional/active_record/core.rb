module Functional
  module ActiveRecord
    module Core
      extend ActiveSupport::Concern

      module ClassMethods
        def find(*)
          Try { super }
        end

        def find_by(*)
          Option(super)
        end

        def find_by!(*args)
          Try do
            find_by(*args).get_or_else do
              fail ::ActiveRecord::RecordNotFound.new("Couldn't find #{name}")
            end
          end
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
