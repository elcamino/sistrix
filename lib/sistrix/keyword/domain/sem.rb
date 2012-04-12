module Sistrix

  require 'sistrix/base'
  class Keyword
    module Domain
      class Sem

        include ::Sistrix::Base

        attr_reader :credits, :results, :date

        def initialize(options = {})
          @options = {
            'domain' => nil,
            'num'  => 5,
            'date' => 'today',
            'search' => nil,
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

            @data[:position] = xml_node['position'].to_s.strip.to_i
            @data[:kw] = xml_node['kw'].to_s.strip
            @data[:competition] = xml_node['competition'].to_s.strip.to_i
            @data[:traffic] = xml_node['traffic'].to_s.strip.to_i
          end
        end


      end

    end
  end
end
