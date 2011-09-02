module Sistrix

  require 'sistrix/base'

  class DomainSichtbarkeitsindex < Sistrix::Base
    METHOD = 'domain.sichtbarkeitsindex'

    attr_reader :credits, :sichtbarkeitsindex

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
      @sichtbarkeitsindex = []
      data.xpath('//answer/sichtbarkeitsindex').each do |o|
        @sichtbarkeitsindex << ::Sistrix::DomainSichtbarkeitsindex::Record.new(o)
      end

      self
    end

    class Record
      require 'sistrix/record'
      include ::Sistrix::Record

      def initialize(xml_node)
        @data = {}

        @data[:domain] = xml_node['domain'].strip
        @data[:date] = xml_node['date'].strip
        @data[:value] = xml_node['value'].strip.to_f
      end
    end

  end

end
