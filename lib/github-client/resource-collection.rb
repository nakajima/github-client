module GitHubClient
  class ResourceCollection
    include Enumerable

    def initialize(list, session)
      @list, @session = list, session
    end

    def length
      @list.length
    end

    alias_method :size, :length

    def each
      @list.each do |login|
        yield @session.users[login]
      end
    end
  end
end
