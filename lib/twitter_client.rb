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
end
