module Sistrix

  require 'sistrix/base'
  class Links
    class Linktargets

      include ::Sistrix::Base

      attr_reader :credits, :targets

      def initialize(options = {})
        @options = {
          'domain' => nil,
          'num' => nil,
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits = data.xpath('/response/credits').first['used'].to_i

        @targets = []
        data.xpath('/response/answer/target').each do |r|
          @targets << Record.new(r)
        end

        self
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def text
          @data[:text]
        end

        def initialize(xml_node)
          @data = {}

          @data[:url] = xml_node['url'].to_s.strip
          @data[:links] = xml_node['links'].to_s.strip.to_i
          @data[:hosts] = xml_node['hosts'].to_s.strip.to_i
          @data[:domains] = xml_node['domains'].to_s.strip.to_i
          @data[:nets] = xml_node['nets'].to_s.strip.to_i
          @data[:ips] = xml_node['ips'].to_s.strip.to_i
        end
      end


    end

  end
end

