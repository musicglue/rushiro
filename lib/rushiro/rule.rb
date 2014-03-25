module Rushiro
  class Rule
    VALUE_SEPARATOR = ','
    SCOPE_SEPARATOR = '|'
    WILDCARD = '*'

    def initialize serialized_rule = ''
      @scopes = Rule.tokenize serialized_rule
    end

    def matches? test_string
      empty_rule = @scopes.empty?

      return false if !empty_rule && test_string.empty?
      return true if empty_rule

      Rule.tokens_match? @scopes, Rule.tokenize(test_string)
    end

    def inspect
      "<Rushiro::Rule:#{object_id} @serialized_string='#{self}'>"
    end

    def to_s
      @serialized_string ||= @scopes.map { |values| values.sort.join(VALUE_SEPARATOR) }.join(SCOPE_SEPARATOR)
    end

    def hash
      to_s.hash
    end

    def eql? other
      self == other
    end

    def == other
      to_s == other.to_s
    end

    def <=> other
      to_s <=> other.to_s
    end

    def self.tokenize string
      string.split(SCOPE_SEPARATOR).map { |scope| scope.split VALUE_SEPARATOR }
    end

    def self.tokens_match? our_tokens, their_tokens
      our_tokens.zip(their_tokens) do |tokens|
        ours, theirs = tokens

        theirs ||= []
        theirs << WILDCARD

        return false if (theirs & ours).empty?
      end

      true
    end
  end
end
