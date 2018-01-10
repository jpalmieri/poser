require 'uri'

class TwitterUser

  def initialize(username)
    @user = client.user(username)
  end

  def original_tweets
    client.user_timeline(@user)
  end

  def cleaned_tweets
    original_tweets.map do |tweet|
      OpenStruct.new(:text => clean_text(tweet.text))
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
