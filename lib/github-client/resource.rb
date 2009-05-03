module GitHubClient
  class Resource
    class << self
      def all(set)
        set[singular.to_s] || set[plural.to_s]
      end

      def from(base)
        @base = base
      end

      def base
        @base.split('/').reject { |s| s =~ /^:/ }.join('/')
      end

      def json(key, opts={})
        @json_keys = opts.merge(:singular => key)
      end

      def singular
        @json_keys[:singular]
      end

      def plural
        @json_keys[:plural] || (singular.to_s + 's')
      end
    end

    def initialize(json, session=nil)
      @json, @session = json, session
    end

    def inspect
      parts = []
      parts << '#<' + self.class.name + ':' + object_id.to_s
      parts << '@json=' + json.inspect
      parts << '>'
      parts.join(' ')
    end

    def pretty_print(a)
      @json.pretty_print(a)
    end

    def json
      @json[self.class.singular.to_s] || @json[self.class.plural.to_s]
    end
  end
end
