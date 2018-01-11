require 'yaml'
require 'uri'

class Utils
  class << self

    def secrets
      YAML.load_file(File.expand_path('../../../secrets.yml', __FILE__))
    end

    def remove_urls(text)
      text.sub(URI.regexp, '')
    end

    def remove_extra_whitespace(text)
      text.split(' ').map {|t| t.strip}.join(' ')
    end

    def truncate_tweet(text, character_limit=140)
      return text if text.length <= character_limit
      if text.scan('.').count > 1 # More than one sentence
        truncate_sentences(text, character_limit)
      else
        truncate_words(text, character_limit)
      end
    end

    def truncate_sentences(text, character_limit)
      # recursiely drop sentences until under character limit
      return text if text.length <= character_limit
      new_text = text.split('.').slice(0..-2).join('.')
      truncate_sentences("#{new_text}.", character_limit)
    end

    def truncate_words(text, character_limit)
      # recursiely drop words until under character limit
      return text if text.length <= character_limit
      new_text = text.split(' ').slice(0..-2).join(' ')
      truncate_words("#{new_text}", character_limit)
    end

  end
end
