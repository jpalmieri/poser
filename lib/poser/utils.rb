require 'yaml'

class Utils
  class << self

    def secrets
      YAML.load_file(File.expand_path('../../../secrets.yml', __FILE__))
    end

  end
end
