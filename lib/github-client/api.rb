require 'open-uri'
require 'yaml'
require 'cgi'

module GitHubClient
  class API
    BASE = 'http://github.com/api/v2/'
    FORMAT = :yaml

    attr_reader :last_response

    def get(path, params={})
      request :get, path, params
    end

    private

    def url_for(path, params)
      BASE + FORMAT.to_s + path + '?' + serialize_query(params)
    end

    def request(verb, path, params={})
      begin
        GitHubClient.logger.trace '%s %s' % [verb.to_s.upcase, path],
          'PARAMS: ' + params.inspect
        YAML.load(open(url_for(path, params)).read)
      rescue => e
        GitHubClient.logger.info 'Throttled!'
        throttling?(e) ? (sleep(THROTTLE_WAIT) and retry) : raise(e)
      end
    end

    def throttling?(err)
      err.is_a?(OpenURI::HTTPError) and err.message == '403 Forbidden'
    end

    def serialize_query(hash)
      hash.inject([]) do |query, (key,val)|
        query << [
          CGI.escape(key.to_s),
          CGI.escape(val.to_s)
        ].join('=')
      end.join('&')
    end
  end
end
