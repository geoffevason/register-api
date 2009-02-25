require 'yaml'
require 'singleton'

module Register
  class Config
    def self.instance
      @instance ||= Register::Config.new
    end
    
    @settings = nil
    
    def [](key)
      fetch(key)
    end
    
    def fetch(key, default=nil)
      @settings[key].nil? ? default : @settings[key]
    end
     
    def initialize
      config_file = ("#{RAILS_ROOT}/config/register.yml")
      if File.exists?(config_file)
        yml_file = File.expand_path(config_file)
        @settings = YAML.load_file(yml_file)[RAILS_ENV] || {}
        
        Register::log! "Loading #{yml_file} file."
      else
        Register::error! "Cannot find register.yml file at #{config_file}."
      end
    rescue ScriptError, StandardError => e
      raise "Error reading register.yml file: #{e}"
    end
  end
end