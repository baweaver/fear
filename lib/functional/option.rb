module Functional
  # Represents optional values. Instances of +Option+
  # are either an instance of +Some+ or the object +None+.
  #
  # The most idiomatic way to use an +Option+ instance is to treat it
  # as a collection or monad and use +map+, +flat_map+, +select+, or +each+:
  #
  # @example
  #   name = Option(params[:name])
  #   upper = name.map(&:strip).select { |n| n.length != 0 }.map(&:upcase)
  #   puts upper.get_or_else('')
  #
  # Because of how for comprehension works, if +None+ is returned
  # from +Option(params[:name])+, the entire expression results is +None+.
  #
  # This allows for sophisticated chaining of +Option+ values without
  # having to check for the existence of a value.
  #
  # A less-idiomatic way to use +Option+ values is via pattern matching:
  #
  # @example
  #   name = Option(params[:name])
  #   case name
  #   when Some
  #     puts name.strip.upcase
  #   when None
  #     puts 'No name value'
  #   end
  #
  # or manually checking for non emptiness:
  #
  # @example
  #   name = Option(params[:name])
  #   if name.present?
  #     puts name.strip.upcase
  #   else
  #     puts 'No name value'
  #   end
  #
  # @abstract Include and implement {+#empty?+}, and {+#get+} to
  #   implement a +Some+ or +None+ value.
  # @see https://github.com/scala/scala/blob/2.11.x/src/library/scala/Option.scala
  #
  module Option
    include Contracts
    include Contracts::Modules

    Contract Contracts::None => None
    def self.empty
      None()
    end

    # @return [true, false] true if the option is +None+,
    #   false otherwise.
    # @abstract
    #
    Contract Contracts::None => Bool
    def empty?
      fail NotImplementedError
    end

    # @return [true, false] true if the option is an instance
    #   of +Some+, false otherwise.
    #
    Contract Contracts::None => Bool
    def present?
      !empty?
    end

    # @return [Object] the option's value.
    # @raise [NoMethodError] if called on +None+
    # @abstract
    #
    Contract Contracts::None => Any
    def get
      fail NotImplementedError
    end

    # @return [Object] the option's value if it is nonempty
    # @yieldreturn [Object] default value if it is empty
    #
    # @example if +Option+ is nonempty
    #   Option(params[:name]).get_or_else('No name') #=> 'Albert'
    #
    # @example if +Option+ is empty
    #   Option(params[:name]).get_or_else('No name') #=> 'No name'
    #
    Contract Func[Contracts::None => Any] => Any
    def get_or_else(&default)
      if empty?
        default.call
      else
        get
      end
    end

    # Returns the option's value if it is nonempty,
    # or +nil+ if it is empty. Useful for unwrapping
    # option's value.
    #
    # @return [Object, nil] the option's value if it is
    #   nonempty or +nil+ if it is empty
    #
    # @example if +Option+ is nonempty
    #   User.find(params[:id]).or_nil #=> <#User id=123>
    #
    # @example if +Option+ is empty
    #   User.find(params[:id]).or_nil #=> nil
    #
    Contract Contracts::None => Or[Any, nil]
    def or_nil
      get_or_else { nil }
    end

    # Returns a +Some+ containing the result of applying
    # +block+ to this option's value if this +Option+ is
    # nonempty. Otherwise return +None+.
    #
    # @yield [option's value] if it is nonempty
    # @return [Some, None]
    #
    # @example if +Option+ is nonempty
    #   User.find(params[:id]).map(&:email) #=> Some('albert@example.com')
    #
    # @example if +Option+ is empty
    #   User.find(params[:id]).map(&:email) #=> None()
    #
    Contract Func[Not[nil] => Not[nil]] => Or[Some, None]
    def map(&block)
      if empty?
        None()
      else
        Some(block.call(get))
      end
    end

    # @param if_empty [Object]
    # @yield [option's value] if nonempty
    # @return [Object] the result of applying +block+ to this
    #   option's value if the option is nonempty.  Otherwise,
    #   return the value of +if_empty+.
    #
    # @example if +Option+ is nonempty
    #   User.find(params[:id]).inject(0) do |user|
    #     user.posts.count
    #   end #=> 42
    #
    # @example if +Option+ is empty
    #   User.find(params[:id]).inject(0) do |user|
    #     user.posts.count
    #   end #=> 0
    #
    Contract Not[nil], Func[Not[nil] => Not[nil]] => Any
    def inject(if_empty, &block)
      if empty?
        if_empty
      else
        block.call(get)
      end
    end

    # @return [Some, None] this +Option+ if it is nonempty and
    #   applying the +predicate+ to this option's value
    #   returns true. Otherwise, return +None+.
    #
    # @example if +Option+ is nonempty
    #   User.find(params[:id]).select do |user|
    #     user.posts.count > 0
    #   end #=> Some(User)
    #
    # @example if +Option+ is empty
    #   User.find(params[:id]).select do |user|
    #     user.posts.count > 0
    #   end #=> None
    #
    # So you can chain calls to +select+ with +map+, +inject+ etc
    # without checking for emptiness.
    #
    # @example
    #   User.find(params[:id])
    #     .select(&:confirmed?)
    #     .map(&:posts)
    #     .inject(0, &:count)
    #
    Contract Func[Not[nil] => Bool] => Or[Some, None]
    def select(&predicate)
      if present? && predicate.call(get)
        self
      else
        None()
      end
    end

    # @return [Some, None] this +Option+ if it is nonempty and
    #   applying the +predicate+ to this option's value returns false.
    #   Otherwise, return +None+.
    #
    # @example if +Option+ is nonempty and satisfy +predicate+
    #   User.find(params[:id]).reject do |user|
    #     user.posts.count > 0
    #   end #=> Some(User)
    #
    # @example if +Option+ is empty
    #   User.find(params[:id]).select do |user|
    #     user.posts.count > 0
    #   end #=> None
    #
    # So you can chain calls to +reject+ with +map+, +inject+ etc
    # without checking for emptiness.
    #
    # @example
    #   User.find(params[:id])
    #     .reject { |u| u.posts.count > 0 }
    #     .map { |u| "#{u.name}, write your first blog post" }
    #
    #
    Contract Func[Not[nil] => Bool] => Or[Some, None]
    def reject(&predicate)
      if present? && !predicate.call(get)
        self
      else
        None()
      end
    end
  end
end
