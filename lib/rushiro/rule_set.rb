module Rushiro
  class RuleSet
    def initialize(level: 'default', mode:)
      @level = level
      @rules = SortedSet.new
      @mode = mode
    end

    def add_rule serialized_rule
      with_applicable_rule(serialized_rule) { |rule| @rules.add rule }
    end

    def remove_rule serialized_rule
      with_applicable_rule(serialized_rule) { |rule| @rules.delete rule }
    end

    def process outcome
      return unless match? outcome.request
      @mode.modify_outcome outcome, @level
    end

    def match? request
      @rules.any? { |rule| rule.matches? request }
    end

    def to_ary
      @rules.map { |rule| @mode.prefix_serialized_rule "#{@level}|#{rule}" }
    end

    private

    def with_applicable_rule rule
      match_data = @mode.match_serialized_rule rule

      return unless match_data
      return unless match_data[1] == @level.to_s

      yield Rule.new(match_data[2])
    end
  end
end
