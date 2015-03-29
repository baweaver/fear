module ActiveRecord
  class Base
    require_relative 'active_record/core'
    require_relative 'active_record/persistence'
    require_relative 'active_model/conversion'
    require_relative 'active_record/querying'
    require_relative 'active_record/validations'

    include Functional::Try
    prepend Functional::ActiveRecord::Core
    prepend Functional::ActiveRecord::Persistence
    prepend Functional::ActiveModel::Conversion
    prepend Functional::ActiveRecord::Querying
    prepend Functional::ActiveRecord::Validations
  end
end

module ActiveRecord
  class Relation
    require_relative 'active_record/relation'

    prepend Functional::ActiveRecord::Relation
  end
end
