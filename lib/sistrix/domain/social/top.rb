module Sistrix

  require 'sistrix/base'

  class Domain
    module Social
      class Top
        include ::Sistrix::Base
        attr_reader :credits, :urls

        def initialize(options = {})
          @options = {
            'domain' => nil,
            'network' => nil,
            'num' => 10,
            'api_key' => Sistrix.config.api_key,
          }.merge(options)

          if Sistrix.config.proxy
            RestClient.proxy = Sistrix.config.proxy
          end
        end

        def call(options = {})
          data = fetch(options)

          @credits = data.xpath('//credits').first['used'].to_i
          @urls = []
          data.xpath('//answer/url').each do |o|
            @urls << Record.new(o)
          end

          self
        end

        class Record
          require 'sistrix/record'
          include ::Sistrix::Record

          def initialize(xml_node)
            @data = {}

            @data[:network] = xml_node['network'].strip
            @data[:url] = xml_node['url'].strip
            @data[:votes] = xml_node['votes'].strip.to_i
          end
        end

      end
    end
  end
end
