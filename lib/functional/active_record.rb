module Functional
  module ActiveRecord
    require_relative 'active_record/core'
    require_relative 'active_record/persistence'
    require_relative 'active_record/validations'

    include Try
    include Persistence
    include Validations
    include Core

    def self.prepended(base)
      class << base
        prepend Functional::ActiveRecord::ClassMethods
      end
    end
  end
end
