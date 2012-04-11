module Sistrix

  require 'sistrix/base'

  class Domain
    class Overview
      include ::Sistrix::Base

      attr_reader :credits, :sichtbarkeitsindex, :pagerank,
                  :pages, :age, :kwcount_seo, :kwcount_sem

      def initialize(options = {})
        @options = {
          'domain' => nil,
          'api_key' => Sistrix.config.api_key,
        }.merge(options)

        if Sistrix.config.proxy
          RestClient.proxy = Sistrix.config.proxy
        end
      end

      def call(options = {})
        data = fetch(options)

        @credits = data.xpath('//credits').first['used'].to_i

        @sichtbarkeitsindex = Record.new(data.xpath('//answer/sichtbarkeitsindex').first)
        @pagerank           = Record.new(data.xpath('//answer/pagerank').first)
        @pages              = Record.new(data.xpath('//answer/pages').first)
        @age                = Record.new(data.xpath('//answer/age').first)
        @kwcount_seo        = Record.new(data.xpath('//answer/kwcount.seo').first)
        @kwcount_sem        = Record.new(data.xpath('//answer/kwcount.sem').first)

        self
      end

      class Record
        require 'sistrix/record'
        include ::Sistrix::Record

        def initialize(xml_node)
          @data = {}

          @data[:domain] = xml_node['domain'].strip

          begin
            @data[:date] = Time.parse(xml_node['date'].strip)
          rescue NoMethodError
            @data[:date] = nil
          end

          if xml_node.name == 'age'
            @data[:value] = Time.parse(xml_node['value'].strip)
          else
            if xml_node['value'] =~ /\./
              @data[:value] = xml_node['value'].strip.to_f
            else
              @data[:value] = xml_node['value'].strip.to_i
            end

          end

        end
      end # class Domain::Overview::Record

    end # class Domain::Overview


  end
end
