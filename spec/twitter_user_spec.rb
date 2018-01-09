require 'spec_helper'

RSpec.describe TwitterUser do
  context "username exists" do
    context "user has tweets" do
      context "with text" do
        pending "returns a concatenated list of tweets"
      end

      context "without text" do
        pending "returns message that no tweets contain text"
      end
    end

    context "user has no tweets" do
      pending "returns message that tweets have no text"
    end
  end

  context "username not found" do
    pending "returns message user not found"
  end
end
