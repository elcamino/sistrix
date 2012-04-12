module Sistrix

  require 'sistrix/base'
  class Keyword
    class Us

      include ::Sistrix::Base

      attr_reader :credits, :results, :date

      def initialize(options = {})
        @options = {
          'kw' => nil,
          'date' => 'today',
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits = data.xpath('/response/credits').first['used'].to_i
        @date    = Time.parse(data.xpath('/response/date').first.to_s)

        @results = []
        data.xpath('/response/answer/result').each do |r|
          @results << Record.new(r)
        end

        self
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:position] = xml_node['position'].strip.to_i
          @data[:position_intern] = xml_node['position.intern'].strip.to_s
          @data[:url] = xml_node['url'].to_s.strip
          @data[:type] = xml_node['type'].to_s.strip
        end
      end


    end

  end
end

