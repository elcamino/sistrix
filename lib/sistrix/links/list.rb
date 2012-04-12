module Sistrix

  require 'sistrix/base'
  class Links
    class List

      include ::Sistrix::Base

      attr_reader :credits, :links

      def initialize(options = {})
        @options = {
          'domain' => nil,
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits = data.xpath('/response/credits').first['used'].to_i

        @links = []
        data.xpath('/response/answer/link').each do |r|
          @lknks << Record.new(r)
        end

        self
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:url_from] = xml_node['url.from'].to_s.strip
          @data[:url_to] = xml_node['url.to'].to_s.strip
          @data[:text] = xml_node['text'].to_s.strip
        end
      end


    end

  end
end

