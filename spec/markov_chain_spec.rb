require 'spec_helper'

RSpec.describe MarkovChain do
  let(:markov_chain) { MarkovChain.new('primer text') }
  let(:dictionary) { double 'dictionary' }

  before do
    allow_any_instance_of(MarkovChain).to receive(:dictionary).and_return(dictionary)
    allow(dictionary).to receive(:parse_string)
    allow(dictionary).to receive(:generate_n_words).with(30).and_return(markov_text)
  end

  describe "#generate_tweet" do
    subject { markov_chain.generate_tweet }

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
