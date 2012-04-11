module Sistrix

  require 'sistrix/base'

  class Domain
    class Pagerank
      include ::Sistrix::Base

      attr_reader :credits, :pageranks

      def initialize(options = {})
        @options = {
          'history' => nil,
          'domain' => nil,
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def fetch(options = {})
        data = super(options)

        @credits = data.xpath('//credits').first['used'].to_i
        @pageranks = []
        data.xpath('//answer/pagerank').each do |o|
          @pageranks << Record.new(o)
        end

        self
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:domain] = xml_node['domain'].strip
          @data[:date] = Time.parse(xml_node['date'].strip)
          @data[:value] = xml_node['value'].strip.to_i
        end
      end

    end

  end
end
