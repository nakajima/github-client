module GitHubClient
  class Session
    def initialize(username=nil, token=nil)
      @username, @token = username, token
    end

    def users
      ResourceProxy.for(User).from(self)
    end

    def repositories
      ResourceProxy.for(Repository).from(self)
    end

    def get(path, params={})
      api.get path, params.merge(credentials || {})
    end

    def credentials
      if @username and @token
        { :login => @username, :token => @token }
      end
    end

    private

    def api
      @api ||= API.new
    end
  end
end
