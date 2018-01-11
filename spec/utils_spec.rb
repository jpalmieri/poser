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
end
