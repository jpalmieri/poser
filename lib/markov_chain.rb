require 'marky_markov'

class MarkovChain
  def initialize(primer_text)
    add_text(primer_text)
  end

  def generate_tweet
    truncate_sentences(generate_text, 140)
  end

  private

  def truncate_sentences(text, character_limit)
    # recursiely drop sentences until under character limit
    return text if text.length <= character_limit
    new_text = text.split('.').slice(0..-2).join('.')
    truncate_sentences("#{new_text}.", character_limit)
  end

  def generate_text
    dictionary.generate_n_words 30
  end

  def dictionary
    @temp_dictionary ||= MarkyMarkov::TemporaryDictionary.new
  end

  def add_text(text)
    dictionary.parse_string(text)
  end
end
