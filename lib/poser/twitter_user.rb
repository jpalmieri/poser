require 'uri'
require 'redis'

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

  def new_tweets?
    return true unless last_cached_tweet_date
    DateTime.parse(last_tweet_date) > DateTime.parse(last_cached_tweet_date)
  end

  def cache_last_tweet_date
    redis.set("#{@username}_last_tweet", last_tweet_date)
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

  def last_cached_tweet_date
    redis.get("#{@username}_last_tweet")
  end

  def last_tweet_date
    original_tweets.first.created_at.to_s
  end

  def redis
    @redis ||= Redis.new
  end
end
