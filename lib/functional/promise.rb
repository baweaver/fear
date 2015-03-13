require 'concurrent'

module Functional
  class Promise
    include Contracts

    def initialize(options = {})
      @result = nil
      @options = options
      @future = Concurrent::Future.new(@options) do
        Try { @result }.flatten
      end
    end

    Contract Contracts::None => Bool
    def completed?
      !@result.nil?
    end

    Contract Contracts::None => Future
    def future
      Future.new(@future, @options)
    end

    Contract Not[StandardError] => Bool
    def success(value)
      complete(Success(value))
    end

    Contract Not[StandardError] => Promise
    def success!(value)
      complete!(Success(value))
    end

    Contract StandardError => Bool
    def failure(error)
      complete(Failure(error))
    end

    Contract StandardError => Promise
    def failure!(error)
      complete!(Failure(error))
    end

    Contract Not[StandardError] => Promise
    def complete!(result)
      if complete(result)
        self
      else
        fail IllegalStateException, 'Promise already completed.'
      end
    end

    # Tries to complete the promise with either a value or the exception.
    #
    # @return    If the promise has already been completed returns
    #            `false`, or `true` otherwise.
    #
    Contract Any => Bool
    def complete(result)
      if completed?
        false
      else
        @result = result
        @future.execute
        true
      end
    end
  end
end
