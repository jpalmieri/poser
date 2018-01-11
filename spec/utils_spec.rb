require 'spec_helper'

RSpec.describe Utils do
  describe ".remove_urls" do
    subject { Utils.remove_urls(text) }
    let(:text) do
      "Hello, my name is Joe and here is a url: http://www.google.com. "\
      "Also, https://www.twitter.com is a url."
    end
    let(:processed_text) do
      "Hello, my name is Joe and here is a url: . "\
      "Also,  is a url."
    end
    subject { is_expected.to eq processed_text }
  end

  describe ".remove_urls" do
    subject { Utils.remove_extra_whitespace(text) }
    let(:text) do
      "Hello, my name is    Joe and here is a url: . "\
      "Also,  is a url."
    end
    let(:processed_text) do
      "Hello, my name is Joe and here is a url: . "\
      "Also, is a url."
    end
    subject { is_expected.to eq processed_text }
  end

  describe ".truncate_tweet" do
    subject { Utils.truncate_tweet(text) }
    context "when the generated text is over 140 characters" do
      context "and multiple sentences" do
        let(:text) do
          "This sentence is 200 characters. Blah blah blah, listen to me. "\
          "I like to tweet, but only the perfect amount. The perfect amount is "\
          "140 characters, which this sentence is over by exactly 60 characters."
        end
        let(:tweet) do
          "This sentence is 200 characters. Blah blah blah, listen to me. "\
          "I like to tweet, but only the perfect amount."
        end

        it "trailing sentences are truncated to meet the 140 character limit" do
          expect(subject).to eq(tweet)
        end
      end

      context "and a single sentence" do
        let(:text) do
          "This sentence is long long blah blah blah, listen to me "\
          "I like to tweet, but only the perfect amount The perfect amount is "\
          "140 characters, which this sentence is over by some amount of characters."
        end
        let(:tweet) do
          "This sentence is long long blah blah blah, listen to me I like to "\
          "tweet, but only the perfect amount The perfect amount is 140 characters,"
        end

        it "trailing words are truncated to meet the 140 character limit" do
          expect(subject).to eq(tweet)
        end
      end
    end
  end
end
