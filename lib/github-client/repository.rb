module GitHubClient
  class Repository < Resource
    from '/repos/show/:username/:repository'
    json :repository, :plural => :repositories

    def self.each(session, set)
      set['repositories'].each do |repo|
        name = repo[:owner] + '/' + File.basename(repo[:url])
        begin
          yield session.repositories[name]
        rescue => e
          GitHubClient.logger.error \
            'Error fetching repository: ' + name, e.inspect
          raise e unless GitHubClient.is.safe?
        end
      end
    end
  end
end
