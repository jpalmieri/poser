require 'marky_markov'

class MarkovChain
  def initialize(ident)
    @ident = ident
  end

  def generate_text
    dictionary.generate_n_words 30
  end

  def add_text(text)
    dictionary.parse_string(text)
  end

  private

  def dictionary
    @temp_dictionary ||= MarkyMarkov::TemporaryDictionary.new
  end
end
