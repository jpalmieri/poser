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

  end
end
