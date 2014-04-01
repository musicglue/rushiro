module Rushiro
  module Modes
    class AllowByDefault
      MATCHER = /^denies\|([^\|]+)\|(.*)/

      def match_serialized_rule serialized_rule
        MATCHER.match serialized_rule
      end

      def modify_outcome outcome, level
        outcome.deny level
      end

      def rules_permit_method
        :none?
      end

      def prefix_serialized_rule serialized_rule
        "denies|#{serialized_rule}"
      end

      def to_s
        'allow_by_default'
      end
    end
  end
end
