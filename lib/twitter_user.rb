require 'uri'

class TwitterUser

  def initialize(username, options={})
    @user = client.user(username)
    @options = {
      # Tweets are now being returned as truncated unless in 'extended mode'
      # https://github.com/sferik/twitter/issues/813
      tweet_mode: options.fetch(:tweet_mode, "extended"),
      # Count is limited to 200 unless you fetch additional responses (TODO)
      # https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
      count:      options.fetch(:count, 200)
    }
  end

  def original_tweets
    client.user_timeline(@user, @options)
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
