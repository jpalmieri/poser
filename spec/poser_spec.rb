require 'spec_helper'

RSpec.describe Poser do
  let(:poser) { Poser.new('johndoe') }

  describe "#markov_tweet" do
    subject { poser.markov_tweet }

    let(:twitter_user) { double 'twitter user' }
    let(:tweet) { OpenStruct.new(:text => 'tweet') }
    let(:cleaned_tweets) { [tweet, tweet, tweet] }
    let(:markov_chain) { double 'markov chain' }

    before do
      allow(MarkovChain).to receive(:new).and_return(markov_chain)
      allow(markov_chain).to receive(:generate_text).and_return(markov_text)
      allow(TwitterUser).to receive(:new).and_return(twitter_user)
      allow(twitter_user).to receive(:cleaned_tweets).and_return(cleaned_tweets)
    end

    context "when the generated text is over 140 characters" do
      let(:markov_text) do
        "This sentence is 200 characters. Blah blah blah, listen to me. "\
        "I like to tweet, but only the perfect amount. The perfect amount is "\
        "140 characters, which this sentence is over by exactly 60 characters."
      end
      let(:markov_tweet) do
        "This sentence is 200 characters. Blah blah blah, listen to me. "\
        "I like to tweet, but only the perfect amount."
      end

      it "removes trailing sentences to meet the 140 character limit" do
        expect(subject).to eq(markov_tweet)
      end
    end
  end
end
