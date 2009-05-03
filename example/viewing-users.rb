$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[.. lib])

require File.join(File.dirname(__FILE__), *%w[.. lib github-client])

# some repos blow up with 404s for some reason. this swallows
# those errors:
GitHubClient.set :safe, true

# Start a session (can be authenticated or not)
session = GitHubClient::Session.new

# Grab a user
user = session.users['nakajima']

def demo(title, opts={})
  puts title
  opts[:view].each do |item|
    puts; p item; pp item; puts
  end
end

# User-based
demo "Viewing repositories",  :view => user.repositories
demo "Viewing followers",     :view => user.followers
demo "Viewing followings",    :view => user.following
