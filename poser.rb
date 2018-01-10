# require all dependency files
Dir[File.expand_path('../lib/*.rb', __FILE__)].each do |file|
  require file
end

class Poser
  attr_reader :tweets

  def initialize(username)
    @tweets = TwitterUser.new(username).cleaned_tweets
    @markov = MarkovChain.new(concatenate_tweets)
  end

  def markov_tweet
    @markov.generate_tweet
  end

  private

  def concatenate_tweets
    @tweets.map {|t| t.text }.join("\n")
  end
end
