class TwitterUser

  def initialize(username)
    @user = client.user(username)
  end

  def tweets
    client.user_timeline(@user)
  end

  private

  def client
    @twitter_client ||= TwitterClient.new
  end
end
