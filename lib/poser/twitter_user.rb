class TwitterUser

  def initialize(username, options={})
    @user = client.user(username)
    @options = {
      # Tweets are now being returned as truncated unless in 'extended mode'
      # https://github.com/sferik/twitter/issues/813
      tweet_mode: options.fetch(:tweet_mode, "extended"),
      count:      options.fetch(:count, 200)
    }
  end

  def original_tweets
    client.get_all_tweets(@user, @options)
  end

  def cleaned_tweets
    original_tweets.map do |tweet|
      # Accessing full_text via attrs due to 'extended mode'
      # https://github.com/sferik/twitter/issues/813
      OpenStruct.new(:text => clean_text(tweet.attrs[:full_text]))
    end
  end

  private

  def client
    @twitter_client ||= TwitterClient.new
  end

  def clean_text(text)
    text = Utils.remove_urls(text)
    Utils.remove_extra_whitespace(text)
  end

end
