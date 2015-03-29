module ActiveRecord
  class Base
    require_relative 'active_record/core'
    require_relative 'active_record/querying'
    require_relative 'active_record/validations'
    require_relative 'active_record/persistence'

    include Functional::Try
    prepend Functional::ActiveRecord::Core
    prepend Functional::ActiveRecord::Querying
    prepend Functional::ActiveRecord::Validations
    prepend Functional::ActiveRecord::Persistence
  end
end

module ActiveRecord
  class Relation
    require_relative 'active_record/relation'

    prepend Functional::ActiveRecord::Relation
  end
end
