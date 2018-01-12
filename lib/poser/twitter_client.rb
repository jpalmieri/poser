require 'twitter'

class TwitterClient < Twitter::REST::Client
  def initialize(options={})
    secrets = {
      consumer_key:        Utils.secrets['twitter']['consumer_key'],
      consumer_secret:     Utils.secrets['twitter']['consumer_secret'],
      access_token:        Utils.secrets['twitter']['access_token'],
      access_token_secret: Utils.secrets['twitter']['access_token_secret']
    }
    @options = {
      # Tweets are now being returned as truncated unless in 'extended mode'
      # https://github.com/sferik/twitter/issues/813
      tweet_mode: options.fetch(:tweet_mode, "extended"),
      count:      options.fetch(:count, 200)
    }
    super(secrets)
  end

  # Fetches 3200 tweets, 200 at a time until an empty response is received
  # May result in rate limiting
  # https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  def get_all_tweets(user)
    options = @options
    collect_with_max_id do |max_id|
      options.merge!({ count: 200, include_rts: true })
      options[:max_id] = max_id unless max_id.nil?
      user_timeline(user, options)
    end
  end

  private

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end
end
