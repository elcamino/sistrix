module Sistrix
  module Record
    def keys
      @data.keys
    end

    def method_missing(name)
      raise Sistrix::ArgumentException.new("there is no data field called \"#{name}\" here!") unless @data.has_key?(name.to_sym)

      @data[name]
    end
  end
end
