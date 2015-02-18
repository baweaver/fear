module Functional
  module ActiveRecord
    module Core
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
              raise ::ActiveRecord::RecordNotFound.new("Couldn't find #{name}")
            end
          end
        end
      end
    end
  end
end
