module Sistrix

  require 'sistrix/base'

  class Links
    class Overview
      include ::Sistrix::Base

      attr_reader :credits, :total, :hosts, :domains, :networks, :class_c

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

        @credits  = data.xpath('//credits').first['used'].to_i
        @total    = data.xpath('/response/answer/total').first['num'].to_s.strip.to_i
        @hosts    = data.xpath('/response/answer/hosts').first['num'].to_s.strip.to_i
        @domains  = data.xpath('/response/answer/domains').first['num'].to_s.strip.to_i
        @networks = data.xpath('/response/answer/networks').first['num'].to_s.strip.to_i
        @class_c  = data.xpath('/response/answer/class_c').first['num'].to_s.strip.to_i

        self
      end
    end # class Links::Overview
  end
end
