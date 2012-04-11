module Sistrix
  module Base
    require 'rest-client'
    require 'nokogiri'

    def fetch(options = {})
      @options.merge!(options)

      # use a file, for testing
      #
      if @options[:__use_xml_file] &&
          File.file?(@options[:__use_xml_file]) &&
          File.readable?(@options[:__use_xml_file])

        response = File.new(@options[:__use_xml_file]).read
      else
        response = RestClient.get(base_uri, { :params => @options })
      end

      Nokogiri::XML(response.to_s)
    end

    def method_name
      # derive the method name from the class name
      #
      self.class.to_s.downcase.sub(/^.+?::/, '').gsub(/::/, '.')
    end

    def base_uri
      'http://' + ::Sistrix::SERVICE_HOST + '/' + method_name
    end
  end
end
