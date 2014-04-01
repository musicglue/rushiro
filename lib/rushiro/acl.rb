module Rushiro
  class Acl
    def initialize levels: default_levels, modes: default_modes
      @levels = [levels].flatten.map &:to_s
      @modes = [modes].flatten.map &:to_s

      @permitted_by_default = false if @modes.include? 'deny_by_default'
      @permitted_by_default = true if @modes.include? 'allow_by_default'

      validate_modes @modes

      @rule_sets = @levels.product(@modes).map do |level, mode|
        RuleSet.new level: level, mode: allowed_modes[mode].new
      end
    end

    def add_rule rule
      @rule_sets.each { |rules| rules.add_rule rule }
    end

    def remove_rule rule
      @rule_sets.each { |rules| rules.remove_rule rule }
    end

    def permit? request
      outcome = Outcome.new request, @levels, @permitted_by_default

      @rule_sets.each { |rules| rules.process outcome }

      outcome.permitted?
    end

    def to_a
      @rule_sets.reduce [], :+
    end

    private

    def allowed_modes
      {
        'allow_by_default' => Rushiro::Modes::AllowByDefault,
        'deny_by_default' => Rushiro::Modes::DenyByDefault
      }
    end

    def default_levels
      %i(individual organization system)
    end

    def default_modes
      allowed_modes.keys
    end

    def validate_modes modes
      fail ArgumentError, ':modes must not be empty' if modes.empty?

      all_modes = allowed_modes.keys.join ', '

      return if modes.all? { |mode| all_modes.include? mode }

      fail ArgumentError, ":modes may only contain these values: #{all_modes}"
    end
  end
end
