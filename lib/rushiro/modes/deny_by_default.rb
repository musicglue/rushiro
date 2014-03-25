module Rushiro
  module Modes
    class DenyByDefault
      MATCHER = /^allows\|([^\|]+)\|(.*)/

      def match_serialized_rule serialized_rule
        MATCHER.match serialized_rule
      end

      def rules_permit_method
        :any?
      end

      def prefix_serialized_rule serialized_rule
        "allows|#{serialized_rule}"
      end

      def acl_permit_method
        :any?
      end
    end
  end
end
