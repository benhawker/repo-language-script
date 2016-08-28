# +Client+ - creates connection to Githib returning a parsed HTTParty response.
#
# Proposed usage:
# => client = Client.new("some_github_login")
# => client.get_repositories

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
  # Raised when GitHub returns a 500 HTTP status code with a message including "Internal Server Error"
  class InternalServerError < StandardError
    def initialize
      super("Github has returned an Internal Server Error. HTTP Status Code 500. Please try again.")
    end
  end

  BASE_URL = "https://api.github.com"

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def get_repositories
    response = self.class.get(url)

    case response.headers["status"]
      when "403 Forbidden" then raise LimitReached
      when "404 Not Found" then raise UserNotFound
      when "500 Internal Server Error" then raise InternalServerError
    end
    response
  end

  private

  def url
    BASE_URL + "/users/#{user}/repos"
  end
end