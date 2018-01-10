require 'spec_helper'

RSpec.describe TwitterUser do
  let(:client) { double 'client' }
  let(:tweet) { OpenStruct.new(:attrs => { full_text: tweet_text }) }
  let(:tweet_text) { "tweet" }
  let(:twitter_user) { TwitterUser.new('jonhdoe') }

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
end
