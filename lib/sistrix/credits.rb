module Sistrix

  require 'sistrix/base'

  class Credits
    include ::Sistrix::Base

    attr_reader :credits, :credits_available

    def initialize(options = {})
      @options = {
        'api_key' => Sistrix.config.api_key,
      }

      if Sistrix.config.proxy
        RestClient.proxy = Sistrix.config.proxy
      end
    end

    def call(options = {})
      data = fetch(options)

      @credits = data.xpath('/response/credits').first['used'].to_i
      @credits_available = data.xpath('/response/answer/credits').first['value'].to_s.strip.to_i

      self
    end
  end
end
