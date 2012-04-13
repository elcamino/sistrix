module Sistrix

  require 'sistrix/base'
  class Monitoring
    class Report
      class Download

        attr_reader :data
        attr_reader :error

        include ::Sistrix::Base

        def initialize(options = {})
          @data, @error = nil, nil

          @options = {
            'project' => nil,
            'report' => nil,
            'date' => nil,
            'api_key' => Sistrix.config.api_key,
          }.merge(options)

          if Sistrix.config.proxy
            RestClient.proxy = Sistrix.config.proxy
          end
        end


        def call(options = {})
          @options.merge!(options)

          response = RestClient.get(base_uri, { :params =>  @options })

          begin
            xml = Nokogiri::XML(response.to_s)
            @error = Error.new(xml.xpath('/response/error').first)
          rescue Exception => ex
            @data = response.to_s
          end

          self
        end

        def error?
          ! @error.nil?
        end

        class Error
          attr_reader :code, :message

          def initialize(xml_node)
            @code = xml_node['error_code'].to_s.strip
            @message = xml_node['error_message'].to_s.strip
          end
        end

      end
    end
  end
end
