require 'redis'

# require all dependency files
Dir[File.expand_path('../poser/*.rb', __FILE__)].each do |file|
  require file
end

class Poser
  attr_reader :tweets

  def initialize(username)
    @username = username
    @markov = MarkovChain.new(username)
    if tweet_cache
      @markov.add_text(tweet_cache)
    else
      update_cache!
    end
  end

  def markov_tweet
    Utils.truncate_tweet(@markov.generate_text)
  end

  def update_cache!
    puts "Updating tweet cache. May take a while..."
    @markov.add_text(tweet_markov_primer)
    cache_tweets
  end

  private

  def twitter_client
    @twitter_client ||= TwitterClient.new
  end

  def tweets
    @tweets ||= twitter_client.get_all_tweets(@username)
  end

  def simple_tweets
    tweets.map do |tweet|
      # Accessing full_text via attrs due to 'extended mode'
      # https://github.com/sferik/twitter/issues/813
      OpenStruct.new(:text => clean_text(tweet.attrs[:full_text]))
    end
  end

  def clean_text(text)
    text = Utils.remove_urls(text)
    Utils.remove_extra_whitespace(text)
  end

  def tweet_markov_primer
    simple_tweets.map {|t| t.text }.join("\n")
  end

  def cache_tweets
    redis.set("#{@username}_tweets", tweet_markov_primer)
  end

  def tweet_cache
    redis.get("#{@username}_tweets")
  end

  def redis
    @redis ||= Redis.new
  end
end
