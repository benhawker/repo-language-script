# +Favorite+ - entry class that returns a users favorite lang after searching their Github repositories.
#
# Proposed usage:
# => favorite = Favorite.new("some_github_login")
# => favorite.favorite

class Favorite
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

  def url
    BASE_URL + "/users/#{user}/repos"
  end

  def get_counts
    array = repos.map { |repo| repo["language"] }
    Hash[array.uniq.map{ |i| [i, array.count(i)] }]
  end

  def repos
    Client.new(user).get_repositories
  end
end