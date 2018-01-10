require 'marky_markov'

class MarkovChain
  def initialize(primer_text)
    add_text(primer_text)
  end

  def generate_text
    dictionary.generate_n_words 30
  end

  private

  def dictionary
    @temp_dictionary ||= MarkyMarkov::TemporaryDictionary.new
  end

  def add_text(text)
    dictionary.parse_string(text)
  end
end
