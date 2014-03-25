module Rushiro
  class Acl
    def initialize levels: %i(individual organization system), mode: :allow_by_default
      mode_class = allowed_modes[mode]

      fail ArgumentError, ":mode must be one of #{allowed_modes.keys.join ', '}" unless mode_class

      @mode = mode_class.new
      @levels = levels.map { |level| Rushiro::Rules.new level: level, mode: @mode }
    end

    def add_rule rule
      @levels.each { |rules| rules.add_rule rule }
    end

    def remove_rule rule
      @levels.each { |rules| rules.remove_rule rule }
    end

    def permit? request
      @levels.send(@mode.acl_permit_method) { |rules| rules.permit? request }
    end

    def to_a
      @levels.reduce [], :+
    end

    private

    def allowed_modes
      {
        allow_by_default: Rushiro::Modes::AllowByDefault,
        deny_by_default: Rushiro::Modes::DenyByDefault
      }
    end
  end
end
