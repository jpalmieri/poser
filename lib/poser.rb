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
    @tweets = TwitterUser.new(@username).cleaned_tweets
    @markov.add_text(concatenate_tweets)
    cache_tweets
  end

  private

  def concatenate_tweets
    @tweets.map {|t| t.text }.join("\n")
  end

  def cache_tweets
    redis.set("#{@username}_tweets", concatenate_tweets)
  end

  def tweet_cache
    redis.get("#{@username}_tweets")
  end

  def redis
    @redis ||= Redis.new
  end
end
