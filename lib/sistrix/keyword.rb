module Sistrix

  require 'sistrix/base'

  class Keyword
    include ::Sistrix::Base

    attr_reader :credits, :options

    def initialize(options = {})
      @options = {
        'kw' => nil,
        'api_key' => Sistrix.config.api_key,
      }.merge(options)

      if Sistrix.config.proxy
        RestClient.proxy = Sistrix.config.proxy
      end
    end

    def call(options = {})
      data = fetch(options)

      @credits = data.xpath('//credits').first['used'].to_i
      @options = []
      data.xpath('//answer/option').each do |o|
        @options << Record.new(o)
      end

      self
    end

    class Record
      require 'sistrix/record'
      include ::Sistrix::Record

      def method
        @data[:method]
      end

      def url
        @data[:url]
      end

      def name
        @data[:name]
      end

      def initialize(xml_node)
        @data = {}

        @data[:method] = xml_node['method'].to_s.strip
        @data[:url] = xml_node['url'].to_s.strip
        @data[:name] = xml_node['name'].to_s.strip
      end
    end

  end

end
