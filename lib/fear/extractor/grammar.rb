module Fear
  module Extractor
    # This module contains syntax nodes for GrammarParser
    # generated by +treetop+.
    module Grammar
      class Node < Treetop::Runtime::SyntaxNode
        def show_position
          "#{input}\n" \
          "#{'~' * interval.first}^"
        end
      end

      class ArrayLiteral < Node
        def to_matcher
          list = elements.slice(1...-1).reject(&:empty?)
          if list.empty?
            EmptyListMatcher.new(
              index: 0,
              node: self,
            )
          else
            list.first.to_matcher
          end
        end
      end

      class ArrayValueList < Node
        def to_matcher
          head, tail = elements.reject(&:empty?)
          ArrayListMatcher.new(
            head: head.to_matcher(0),
            tail: tail ? tail.to_matcher(1) : EmptyListMatcher.new(index: 1, node: self),
            index: 0,
            node: self,
          )
        end
      end

      class Expression < Node
      end

      class ArrayTail < Node
        def to_matcher(index)
          head, tail = elements[1]
          head = head.elements[0]
          ArrayListMatcher.new(
            head: head.to_matcher(index),
            tail: tail ? tail.to_matcher(1) : EmptyListMatcher.new(index: 1, node: self),
            index: index,
            node: self,
          )
        end
      end

      class ArrayTailSplat < Node
        def to_matcher(index)
          splat, = elements[1]
          ArrayListMatcher.new(
            head: splat.to_matcher,
            tail: EmptyListMatcher.new(index: index + 1, node: self),
            index: index,
            node: self,
          )
        end
      end

      class ArrayHead < Node
        def to_matcher(index)
          ArrayHeadMatcher.new(
            element: elements[1].to_matcher,
            index: index,
            node: self,
          )
        end
      end

      class ArraySplat < Node
        def to_matcher
          elements[1].to_matcher
        end
      end

      class AnonymousArraySplat < Node
        def to_matcher
          AnonymousArraySplatMatcher.new(node: self)
        end
      end

      class FloatLiteral < Node
        def to_matcher
          NumberMatcher.new(value: value, node: self)
        end

        def value
          text_value.to_f
        end
      end

      class IntegerLiteral < Node
        def to_matcher
          NumberMatcher.new(value: value, node: self)
        end

        def value
          text_value.to_i
        end
      end

      class StringLiteral < Node
        def value
          text_value
        end
      end
    end
  end
end
