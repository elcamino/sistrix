module Sistrix

  require 'sistrix/base'

  class Domain
    module Social
      class Url
        include ::Sistrix::Base
        attr_reader :credits, :url, :total, :facebook,
                    :twitter, :googleplus, :history

        def initialize(options = {})
          @options = {
            'domain' => nil,
            'history' => nil,
            'api_key' => Sistrix.config.api_key,
          }.merge(options)

          if Sistrix.config.proxy
            RestClient.proxy = Sistrix.config.proxy
          end
        end

        def call(options = {})
          data = fetch(options)

          @credits = data.xpath('//credits').first['used'].to_i
          @votes = []

          current_node = data.xpath('/response/answer/current').first
          @url = current_node['url']
          @total = current_node['total'].to_i
          @facebook = current_node['facebook'].to_i
          @twitter = current_node['twitter'].to_i
          @googleplus = current_node['googleplus'].to_i

          @history = []
          data.xpath('/response/answer/timeline/history').each do |o|
            @history << Record.new(o)
          end

          self
        end

        class Record
          require 'sistrix/record'
          include ::Sistrix::Record

          def initialize(xml_node)
            @data = {}

            @data[:date] = Time.parse(xml_node['date'].strip)
            @data[:total] = xml_node['total'].strip.to_i
            @data[:facebook] = xml_node['facebook'].strip.to_i
            @data[:twitter] = xml_node['twitter'].strip.to_i
            @data[:googleplus] = xml_node['googleplus'].strip.to_i
          end
        end

      end
    end
  end
end
