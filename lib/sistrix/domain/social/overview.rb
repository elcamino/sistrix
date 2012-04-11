module Sistrix

  require 'sistrix/base'

  class Domain
    module Social
      class Overview
        include ::Sistrix::Base

        attr_reader :credits, :twitter, :facebook, :googleplus

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

          @credits    = data.xpath('//credits').first['used'].to_i
          @twitter    = data.search('/response/answer/votes[@network="twitter"]').first['value'].to_i
          @facebook   = data.search('/response/answer/votes[@network="facebook"]').first['value'].to_i
          @googleplus = data.search('/response/answer/votes[@network="googleplus"]').first['value'].to_i

          self
        end
      end # class Domain::Social::Overview
    end # module Domain::Social
  end # class Domain
end # module Sistrix
