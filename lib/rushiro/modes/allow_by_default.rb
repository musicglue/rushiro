module Rushiro
  module Modes
    class AllowByDefault
      MATCHER = /^denies\|([^\|]+)\|(.*)/

      def match_serialized_rule serialized_rule
        MATCHER.match serialized_rule
      end

      def rules_permit_method
        :none?
      end

      def prefix_serialized_rule serialized_rule
        "denies|#{serialized_rule}"
      end

      def acl_permit_method
        :all?
      end
    end
  end
end
