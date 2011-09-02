module Sistrix
  class Base
    require 'rest-client'
    require 'nokogiri'

    def fetch(options = {})
      @options.merge!(options)

      response = RestClient.get(base_uri, { :params => @options })
      Nokogiri::XML(response.to_s)
    end

    def method_name
      self.class::METHOD
    end

    def base_uri
      'http://' + ::Sistrix::SERVICE_HOST + '/' + method_name
    end
  end
end
