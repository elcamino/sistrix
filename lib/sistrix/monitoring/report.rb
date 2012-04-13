module Sistrix

  require 'sistrix/base'
  class Monitoring
    class Report

      include ::Sistrix::Base

      attr_reader :credits, :name, :id, :frequency, :format, :recipients, :reports

      def initialize(options = {})
        @options = {
          'project' => nil,
          'report' => nil,
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits   = data.xpath('/response/credits').first['used'].to_i
        @name      = data.xpath('/response/answer/name').first['value'].to_s.strip
        @id        = data.xpath('/response/answer/id').first['value'].to_s.strip
        @frequency = data.xpath('/response/answer/frequency').first['value'].to_s.strip
        @format    = data.xpath('/response/answer/format').first['value'].to_s.strip

        @recipients = []
        data.xpath('/response/answer/recipients/recipient').each do |r|
          @recipients << Recipient.new(r)
        end

        @reports = []
        data.xpath('/response/answer/archive/report').each do |r|
          @reports << Record.new(r)
        end

        self
      end

      class Recipient
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:value] = xml_node['value'].to_s.strip
          @data[:type] = xml_node['type'].to_s.strip
        end
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:date] = Time.parse(xml_node['date'].to_s.strip)
          @data[:format] = xml_node['format'].to_s.strip
        end
      end


    end

  end
end

