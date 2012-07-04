module RSpec
  module Matchers
    module BuiltIn
      class Eq
        include BaseMatcher

        def matches?(actual)
          super(actual) == expected
        end

        def failure_message_for_should
          "\nexpected: #{expected.inspect}\n     got: #{actual.inspect}\n\n(compared using ==)\n"
        end

        def failure_message_for_should_not
          "\nexpected: value != #{expected.inspect}\n     got: #{actual.inspect}\n\n(compared using ==)\n"
        end

        def diffable?
          true
        end
      end
    end
  end
end

