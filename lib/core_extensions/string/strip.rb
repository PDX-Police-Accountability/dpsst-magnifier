module CoreExtensions
  module String
    module Strip
      def strip_whitespace
        self.gsub(/^[[:space:]]+/, "").gsub(/[[:space:]]+$/, "")
      end

      def strip_whitespace!
        self.gsub!(/^[[:space:]]+/, "").gsub!(/[[:space:]]+$/, "")
      end
    end
  end
end
