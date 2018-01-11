require 'twitter'

class TwitterClient < Twitter::REST::Client
  def initialize
    options = {
      consumer_key:        Utils.secrets['twitter_consumer_key'],
      consumer_secret:     Utils.secrets['twitter_consumer_secret'],
      access_token:        Utils.secrets['twitter_access_token'],
      access_token_secret: Utils.secrets['twitter_access_token_secret']
    }
    super(options)
  end

  # Fetches 3200 tweets, 200 at a time until an empty response is received
  # May result in rate limiting
  # https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  def get_all_tweets(user, options={})
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
