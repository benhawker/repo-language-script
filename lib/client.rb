# +Client+ - entry class that returns a users favorite lang after searching their Github repositories.
#
# Proposed usage:
# => client = Client.new("some_github_login")
# => client.favorite

require 'httparty'

class Client
  include HTTParty

  # Raised when Github returns a 404 HTTP status code. Likely to mean the user is not found.
  class UserNotFound < StandardError
    def initialize
      super("This user is not found. Please check you have a correct Github username.")
    end
  end
  # Raised when GitHub returns a 403 HTTP status code with a message including "Limit exceeded"
  class LimitReached < StandardError
    def initialize
      super("Your IP has been rate limited by Github, please try again later.")
    end
  end

  BASE_URL = "https://api.github.com"

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def favorite
    puts "#{user}'s favorite language seems to be #{favorites_list.join(favorites_list.size > 1 ? (" and ") : ())}."
  end

  private

  def favorites_list
    counts = get_counts
    result = []

    counts.each { |k, v| result << k if v == counts.values.max }
    result
  end

  def get_repositories
    response = self.class.get(url)

    case response.headers["status"]
      when "403 Forbidden" then raise LimitReached
      when "404 Not Found" then raise UserNotFound
    end
    response
  end

  def url
    BASE_URL + "/users/#{user}/repos"
  end

  def get_counts
    array = get_repositories.map { |repo| repo["language"] }
    Hash[array.uniq.map{ |i| [i, array.count(i)] }]
  end
end