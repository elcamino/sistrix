module Sistrix

  require 'sistrix/base'

  class Domain
    include ::Sistrix::Base

    attr_reader :credits, :options

    def initialize(options = {})
      @options = {
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
      @options = []
      data.xpath('//answer/option').each do |o|
        @options << ::Sistrix::Domain::Record.new(o)
      end

      self
    end

    class Record
      require 'sistrix/record'
      include ::Sistrix::Record

      def initialize(xml_node)
        @data = {}

        @data[:method] = xml_node['method']
        @data[:url] = xml_node['url']
        @data[:name] = xml_node['name']
      end
    end

  end

end
