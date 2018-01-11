# require all dependency files
Dir[File.expand_path('../lib/*.rb', __FILE__)].each do |file|
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
    truncate_sentences(@markov.generate_text, 140)
  end

  def update_cache!
    @tweets = TwitterUser.new(@username).cleaned_tweets
    @markov.add_text(concatenate_tweets)
    cache_tweets
  end

  private

  def truncate_sentences(text, character_limit)
    # recursiely drop sentences until under character limit
    return text if text.length <= character_limit
    new_text = text.split('.').slice(0..-2).join('.')
    truncate_sentences("#{new_text}.", character_limit)
  end

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
