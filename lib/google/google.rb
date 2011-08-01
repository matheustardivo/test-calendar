require 'rubygems'
require 'oauth'
require 'rexml/document'

module Google
  
  class Client
    attr_accessor :token
    attr_accessor :version
    
    def initialize(token, version = '1.0')
      @token = token
      @version = version
    end
  
    def get(base, query_parameters = {})
      make_request(:get, url(base, query_parameters))
    end
    
    def make_request(method, url)
      response = @token.request(method, url, { 'GData-Version' => version })
      if response.is_a?(Net::HTTPFound)
        url = response['Location']
        return make_request(method, response['Location'])
      end
      return unless response.is_a?(Net::HTTPSuccess)
      REXML::Document.new(response.body)
    end

    private  
      def url(base, query_parameters)
        puts "base: #{base}"
        puts "query_parameters: #{query_parameters}"
        url = base + '?alt=jsonc&'
        unless query_parameters.empty?
          query_parameters.each {|key, value| url += "#{CGI::escape(key)}=#{CGI::escape(value)}&"}
        end
        url.chop!
        url
      end
      
  end
end

