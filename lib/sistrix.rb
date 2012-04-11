module Sistrix
  require 'sistrix/config'

  SERVICE_HOST = 'api.sistrix.net'


  def self.method_missing(sym, *args, &block)
    clazz_name = 'Sistrix::' + sym.to_s.split(/_/).map { |w| w[0].upcase + w[1..w.length] }.join('::')
    lib_name   = 'sistrix/' + sym.to_s.gsub(/_/, '/')
    require lib_name

    clazz = class_from_string(clazz_name)
    return clazz.new(args[0]).call
  end

  protected

  def self.class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end

end

