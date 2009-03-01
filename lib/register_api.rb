require "net/http"
require "net/https"
require "open-uri"

require "hpricot"

 
module Register  
  module Api
    def self.call(command, options)      
      if Register::Config.instance['use_https']
        http = Net::HTTP.new(Register::Config.instance['register_api_url'], 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      else
        http = Net::HTTP.new(Register::Config.instance['register_api_url'], 80)
      end
      
      # Merging like this allows us to pass in override values.
      options = {
        :UID => Register::Config.instance['uid'] ,
        :PW => Register::Config.instance['password'], 
        :ResponseType => 'XML'
      }.merge(options)
      
      path = "/interface.asp"
      data = "Command=#{command}&#{params_to_query_string(options)}"
      headers = {'Content-Type'=> 'application/x-www-form-urlencoded'}
 
      Register::log! "Posting: #{command}"
      Register::log! "#{path}?#{data}"

      resp, data = http.post(path, data, headers)
      doc = Hpricot::XML(data)
      
      errors = []
      if (doc/'interface-response').blank?
        errors << "Invalid interface-response (can't find the XML response)"
      end
      if (doc/'ErrCount').inner_text.to_i > 0
        (doc/'errors').first.children.each do |e|
          errors << e.inner_text unless e.inner_text.blank?
        end
      end
      
      if errors.size > 0
        Register::error! errors.join(", ")
        raise RegisterApiError, errors.join(", ")
      end
      
      return doc
    end
  
    def self.mock(command, options)
      doc = Hpricot::XML(File.open(File.join(File.dirname(__FILE__), '../', 'test', 'responses', "#{Inflector.underscore(command)}_valid.xml")))
    end
    
    # Fun meta stuff so we can call any method we want.
    def self.method_missing(m, *args)
      command = m
      command = Inflector.camelize(m) if Object.const_defined?(:Inflector)
      if Register::Config.instance['use_mocks']
        self.mock(command, *args)
      else
        self.call(command, *args)
      end
    end
    
    def self.params_to_query_string(args={})
      args.map { |k,v| "%s=%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&') unless args.blank?
    end  
  end
end



