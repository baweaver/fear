module Functional
  # The +Try+ represents a computation that may either result
  # in an exception, or return a successfully computed value.
  #
  # Instances of +Try+, are either an instance of +Success+ or
  # +Failure+.
  #
  # For example, +Try+ can be used to perform division on a
  # user-defined input, without the need to do explicit
  # exception-handling in all of the places that an exception
  # might occur.
  #
  # @example
  #   dividend = Try { params[:dividend].to_i }
  #   divisor = Try { params[:divisor].to_i }
  #   problem = dividend.flat_map { |x| divisor.map { |y| x / y }
  #
  #   if problem.success?
  #     puts "Result of #{dividend.get} / #{divisor.get} is: #{problem.get}"
  #   else
  #     puts "You must've divided by zero or entered something wrong. Try again"
  #     puts "Info from the exception: #{problem.exception.message}"
  #   end
  #
  # An important property of +Try+ shown in the above example is its
  # ability to +pipeline+, or chain, operations, catching exceptions
  # along the way. The +flat_map+ and +map+ combinators in the above
  # example each essentially pass off either their successfully completed
  # value, wrapped in the +Success+ type for it to be further operated
  # upon by the next combinator in the chain, or the exception wrapped
  # in the +Failure+ type usually to be simply passed on down the chain.
  # Combinators such as +rescue+ and +recover+ are designed to provide some
  # type of default behavior in the case of failure.
  #
  # @note only non-fatal exceptions are caught by the combinators on +Try+.
  # Serious system errors, on the other hand, will be thrown.
  #
  # @note all +Try+ combinators will catch exceptions and return failure
  # unless otherwise specified in the documentation.
  #
  # @author based on Twitter's original implementation.
  # @see https://github.com/scala/scala/blob/2.11.x/src/library/scala/util/Try.scala
  #
  module Try
    include Contracts

    # @return [true, false] +true+ if the +Try+ is a +Success+,
    #   +false+ otherwise.
    # @abstract
    #
    Contract Contracts::None => Bool
    def success?
      fail NotImplementedError
    end

    # @return [true, false] +true+ if the +Try+ is a +Failure+,
    #   +false+ otherwise.
    #
    Contract Contracts::None => Bool
    def failure?
      !success?
    end

    # @return [value] the value from this +Success+.
    # @raise [exception] this is a +Failure+.
    # @abstract
    #
    def get
      fail NotImplementedError
    end

    # @return [value] if this is a +Success+.
    # @yieldreturn if this is a +Failure+.
    # @raise exception if it is not a success and +block+
    #   throws an exception.
    #
    Contract Func[Contracts::None => Any] => Any
    def get_or_else
      if success?
        get
      else
        yield
      end
    end

    # @return [self] if it's a +Success+
    # @yieldreturn if this is a +Failure+
    #
    Contract Func[Contracts::None => Or[Success, Failure]] => Or[Success, Failure]
    def or_else
      if success?
        self
      else
        yield
      end
    end

    # @return [None] if this is a +Failure+
    # @return [Some<value>] if this is a +Success+.
    #
    Contract Contracts::None => Or[Some, None]
    def to_option
      if success?
        Some(get)
      else
        None()
      end
    end

    # Transforms a nested +Try+, ie, a +Success+ of +Success++,
    # into an un-nested +Try+, ie, a +Success+.
    # @return [Try]
    #
    Contract Contracts::None => Or[Success, Failure]
    def flatten
      if success? && get.is_a?(Try)
        get.flatten
      else
        self
      end
    end

    # Applies the given block if this is a +Success+
    #
    # @return [self]
    # @yieldparam [value]
    # @note if +block+ throws exception, then this method may
    # throw an exception.
    #
    Contract Func[Not[StandardError] => Any] => Or[Success, Failure]
    def each
      yield get if success?
      self
    end

    # @return [Try] the given function applied to the value from this
    #   +Success+ or returns +self+ if this is a +Failure+.
    #
    Contract Func[Not[StandardError] => Any] => Or[Success, Failure]
    def flat_map(&block)
      map(&block).flatten
    end

    # Maps the given function to the value from this
    # +Success+ or returns +self+ if this is a +Failure+.
    # @return [Try]
    #
    Contract Func[Not[StandardError] => Any] => Or[Success, Failure]
    def map(&block)
      if success?
        Try { block.call(get) }
      else
        self
      end
    end

    # Converts this to a +Failure+ if the predicate
    # is not satisfied.
    # @return [Try]
    #
    Contract Func[Not[StandardError] => Bool] => Or[Success, Failure]
    def select(&predicate)
      return self if failure?
      Try do
        if predicate.call(get)
          get
        else
          fail "Predicate does not hold for #{get}"
        end
      end
    end

    # Applies the given +block+ if this is a +Failure+,
    # otherwise returns this if this is a +Success+.
    # This is like +flat_map+ for the exception.
    # @return [Try]
    #
    Contract Func[StandardError => Any] => Or[Success, Failure]
    def recover_with(&block)
      if success?
        self
      else
        recover(&block).flatten
      end
    end

    # Applies the given +block+ if this is a +Failure+,
    # otherwise returns this if this is a +Success+.
    # This is like map for the exception.
    # @return [Try]
    #
    Contract Func[StandardError => Any] => Or[Success, Failure]
    def recover(&block)
      if success?
        self
      else
        Try { block.call(exception) }
      end
    end
  end
end
