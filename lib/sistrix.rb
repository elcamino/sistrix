module Sistrix
  require 'sistrix/config'

  SERVICE_HOST = 'api.sistrix.net'


  def self.method_missing(sym, *args, &block)
    clazz_name = 'Sistrix::' + sym.to_s.split(/_/).map { |w| w[0].upcase + w[1..w.length] }.join('::')
    lib_name   = 'sistrix/' + sym.to_s.gsub(/_/, '/')
    require lib_name

    clazz = class_from_string(clazz_name)
    return clazz.new(args[0]).fetch
  end

  protected

  def self.class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end

end

__END__

  def self.domain_pages(options = {})
    ::Sistrix::DomainPages.new.fetch(options)
  end

  def self.domain_pagerank(options = {})
    ::Sistrix::DomainPagerank.new.fetch(options)
  end

  def self.domain_age(options = {})
    ::Sistrix::DomainAge.new.fetch(options)
  end

  def self.domain_competitors_seo(options = {})
    ::Sistrix::DomainCompetitorsSeo.new.fetch(options)
  end

  def self.domain_competitors_sem(options = {})
    ::Sistrix::DomainCompetitorsSem.new.fetch(options)
  end

  def self.domain_competitors_us(options = {})
    ::Sistrix::DomainCompetitorsUs.new.fetch(options)
  end

  def self.domain_kwcount_seo(options = {})
    ::Sistrix::DomainKwcountSeo.new.fetch(options)
  end

  def self.domain_kwcount_sem(options = {})
    ::Sistrix::DomainKwcountSem.new.fetch(options)
  end

end
