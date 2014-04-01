module Rushiro
  module Modes
    class DenyByDefault
      MATCHER = /^allows\|([^\|]+)\|(.*)/

      def match_serialized_rule serialized_rule
        MATCHER.match serialized_rule
      end

      def modify_outcome outcome, level
        outcome.permit level
      end

      def rules_permit_method
        :any?
      end

      def prefix_serialized_rule serialized_rule
        "allows|#{serialized_rule}"
      end

      def to_s
        'deny_by_default'
      end
    end
  end
end
