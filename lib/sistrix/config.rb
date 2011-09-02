require "singleton"

module Sistrix
  class Config
    include Singleton
    attr_accessor :api_key, :proxy
  end

  def self.config
    if block_given?
      yield Config.instance
    end
    Config.instance
  end
end
