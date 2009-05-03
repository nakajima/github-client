module GitHubClient
  class User < Resource
    from '/user/show/:username'
    json :user

    def self.each(session, set)
      set['users'].each do |login|
        yield session.users[login]
      end
    end

    def followers
      users = ResourceProxy.for(User).from(@session)
      users.scope { |val| val + json['login'] + '/followers' }
      users
    end

    def following
      users = ResourceProxy.for(User).from(@session)
      users.scope { |val| val + json['login'] + '/following' }
      users
    end

    def repositories
      repos = ResourceProxy.for(Repository).from(@session)
      repos.scope { |val| val + json['login'] }
      repos
      # ResourceCollection.new(@session.get(repos.path)['repositories'], @session)
    end

    private

    def load(key)
      GitHubClient.logger.info 'Loading ' + key.to_s
      @session.get(proxy.path(key))['users']
    end

    def proxy
      @proxy ||= begin
        res = ResourceProxy.for(User).from(@session)
        res.path { |val| json['login'] + val }
        res
      end
    end
  end
end
