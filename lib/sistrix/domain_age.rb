module Sistrix
  require 'sistrix/base'

  class DomainAge < Sistrix::Base
    METHOD = 'domain.age'

    attr_reader :credits, :age, :domain

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
      age_node = data.xpath('//answer/age').first
      @age     = age_node['value']
      @domain  = age_node['domain']

      self
    end

  end

end
