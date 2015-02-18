module Functional
  module ActiveRecord
    require_relative 'active_record/persistence'

    include Try
    include Persistence
  end
end
