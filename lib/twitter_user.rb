require 'uri'

class TwitterUser

  def initialize(username)
    @user = client.user(username)
  end

  def original_tweets
    # Tweets are now being returned as truncated unless in 'extended mode'
    # https://github.com/sferik/twitter/issues/813
    client.user_timeline(@user, tweet_mode: "extended")
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

  def remove_urls(text)
    text.sub(URI.regexp, '')
  end

  def remove_extra_whitespace(text)
    text.split(' ').map {|t| t.strip}.join(' ')
  end

  def clean_text(text)
    text = remove_urls(text)
    remove_extra_whitespace(text)
  end
end
