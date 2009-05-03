module GitHubClient
  # Makes Resource traversal accessible in different
  # places, allowing the same type of object to be used
  # for both things like
  #
  #   session.repositories['nakajima/github-client']
  #
  # as well as...
  #
  #   user.repositories['github-client']
  #
  # TODO Clean it up and and make better distinction about
  # difference between this and other resources.
  class ResourceProxy
    class << self
      def for(klass)
        new(klass)
      end
    end

    def initialize(klass)
      @klass = klass
    end

    def [](val)
      @klass.new(session.get(path(val)), session)
    end

    def each
      @klass.each(session, session.get(path)) do |item|
        yield item
      end
    end

    def from(session)
      @session = session ; self
    end

    def scope(&block)
      @block = block
    end

    def path(suffix='')
      res = @block ?
        case @block.arity
        when 1 then @block.call(@klass.base + '/')
        when 2 then @block.call(@klass.base + '/', suffix)
        else @block.call
        end : @klass.base + '/' + suffix
      GitHubClient.logger.debug 'Path for ' + @klass.to_s, res
      res
    end

    private

    def session
      @session || API.new
    end

    def key
      @klass.name.split('::').last.downcase
    end
  end
end
