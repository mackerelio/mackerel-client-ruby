module Mackerel
  class Client
    module Helper
      def self.as_safe_metric_name(str, replacement = '-')
        str.gsub(/[^a-zA-Z0-9_\-]/, replacement)
      end
    end
  end
end
