require 'spec_helper'

RSpec.describe Poser do
  let(:poser) { Poser.new('johndoe') }
  let(:markov_chain) { double 'markov chain' }
  let(:markov_text) { "markov_text" }
  let(:twitter_client) { double 'twitter_client' }
  let(:tweet) { OpenStruct.new(:attrs => { full_text: "tweet" }) }
  let(:tweets) { [tweet, tweet, tweet] }
  let(:redis) { double 'redis' }

  before do
    allow(MarkovChain).to receive(:new).and_return(markov_chain)
    allow(markov_chain).to receive(:add_text).and_return(markov_text)
    allow(TwitterClient).to receive(:new).and_return(twitter_client)
    allow(twitter_client).to receive(:get_all_tweets).and_return(tweets)
    allow(Redis).to receive(:new).and_return(redis)
    allow(redis).to receive(:set)
  end

  describe "#initialize" do
    subject { poser }

    context "when no tweet cache exists" do
      before do
        allow(redis).to receive(:get).and_return(nil)
      end

      it "fetches and caches tweets" do
        expect(twitter_client).to receive(:get_all_tweets)
        expect(redis).to receive(:set)
        subject
      end
    end

    context "when tweet cache exists" do
      before do
        allow(redis).to receive(:get).and_return("tweet\ntweet\ntweet")
      end

      it "doesn't fetch or cache new tweets" do
        expect(twitter_client).not_to receive(:get_all_tweets)
        expect(redis).not_to receive(:set)
        subject
      end
    end
  end
end
