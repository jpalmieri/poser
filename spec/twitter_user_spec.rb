require 'spec_helper'

RSpec.describe TwitterUser do
  let(:twitter_user) { TwitterUser.new('jonhdoe') }

  let(:client) { double 'client' }
  let(:tweet) { OpenStruct.new(:attrs => { full_text: tweet_text }) }
  let(:tweet_text) { "tweet" }

  before do
    allow_any_instance_of(TwitterUser).to receive(:client).and_return(client)
    allow(client).to receive(:user).and_return("John Doe")
  end

  describe '#cleaned_tweets' do
    subject { twitter_user.cleaned_tweets }

    context 'with urls in source tweets text' do
      let(:tweet_text) { "Blah blah blah https://t.co/xs0FXqhkVF boop bop" }
      before do
        allow(client).to receive(:user_timeline).and_return([tweet])
      end

      it 'removes the urls' do
        expect(subject.first.text).to eq("Blah blah blah boop bop")
      end
    end
  end

  describe '#new_tweets?' do
    subject { twitter_user.new_tweets? }

    let(:raw_tweet) { OpenStruct.new(:created_at => Time.parse("2018-01-10 20:08:37 UTC")) }
    let(:new_raw_tweet) { OpenStruct.new(:created_at => Time.now) }

    context 'when no cached tweet' do
      before do
        allow(client).to receive(:user_timeline).and_return([new_raw_tweet])
      end

      it { is_expected.to be true }
    end

    context 'when tweet cache exists' do
      let(:redis) { double 'redis' }

      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(raw_tweet.created_at.to_s)
      end

      context 'and cached tweet is same as newest tweet' do
        before do
          allow(client).to receive(:user_timeline).and_return([raw_tweet])
        end
        it { is_expected.to be false }
      end

      context 'and cached tweet is older than newest tweet' do
        before do
          allow(client).to receive(:user_timeline).and_return([new_raw_tweet, raw_tweet])
        end
        it { is_expected.to be true }
      end
    end
  end
end
