require 'pp'
require 'ostruct'

require 'github-client/api'
require 'github-client/session'
require 'github-client/resource'
require 'github-client/resource-collection'
require 'github-client/resource-proxy'
require 'github-client/repository'
require 'github-client/user'
require 'github-client/logger'

module GitHubClient
  # Specify wait time before resuming requests after getting
  # throttled by GitHub API.
  THROTTLE_WAIT = 10

  def self.set(key,val)
    pred = (key.to_s + '?').to_sym
    (@options ||= {})[pred] = val
  end

  def self.is
    OpenStruct.new(@options)
  end

  def self.logger
    @logger ||= begin
      l = Logger.new
      l.level = :error
      l
    end
  end

  set :safe, ENV['SAFE']
  set :verbose, ENV['VERBOSE']
end
