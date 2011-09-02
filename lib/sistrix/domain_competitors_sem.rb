module Sistrix

  require 'sistrix/base'

  class DomainCompetitorsSem < Sistrix::Base
    METHOD = 'domain.competitors.sem'

    attr_reader :credits, :competitors

    def initialize(options = {})
      @options = {
        'num'    => 5,
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
      @competitors = []
      data.xpath('//answer/result').each do |r|
        @competitors << ::Sistrix::DomainCompetitorsSem::Record.new(r)
      end

      self
    end

    class Record
      require 'sistrix/record'
      include ::Sistrix::Record

      def initialize(xml_node)
        @data = {}

        @data[:domain] = xml_node['domain'].strip
        @data[:match] = xml_node['match'].strip
      end
    end


  end

end
