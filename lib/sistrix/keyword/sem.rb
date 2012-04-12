module Sistrix

  require 'sistrix/base'
  class Keyword
    class Sem

      include ::Sistrix::Base

      attr_reader :credits, :results, :date

      def initialize(options = {})
        @options = {
          'kw' => nil,
          'num'  => 5,
          'date' => 'today',
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
          @data[:title] = xml_node['title'].to_s.strip
          @data[:text] = xml_node['text'].to_s.strip
          @data[:displayurl] = xml_node['displayurl'].to_s.strip
        end
      end


    end

  end
end

