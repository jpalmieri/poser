require 'twitter'
require 'yaml'

class TwitterClient < Twitter::REST::Client
  def initialize
    options = {
      consumer_key:        secrets['twitter_consumer_key'],
      consumer_secret:     secrets['twitter_consumer_secret'],
      access_token:        secrets['twitter_access_token'],
      access_token_secret: secrets['twitter_access_token_secret']
    }
    super(options)
  end

  private

  def secrets
    YAML.load_file('../secrets.yml')
  end
end
