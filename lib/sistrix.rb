module Sistrix
  require 'sistrix/config'

  autoload :Domain,                   'sistrix/domain'
  autoload :DomainSichtbarkeitsindex, 'sistrix/domain_sichtbarkeitsindex'
  autoload :DomainPages,              'sistrix/domain_pages'
  autoload :DomainPagerank,           'sistrix/domain_pagerank'
  autoload :DomainAge,                'sistrix/domain_age'
  autoload :DomainCompetitorsSeo,     'sistrix/domain_competitors_seo'
  autoload :DomainCompetitorsSem,     'sistrix/domain_competitors_sem'
  autoload :DomainCompetitorsUs,      'sistrix/domain_competitors_us'
  autoload :DomainKwcountSeo,         'sistrix/domain_kwcount_seo'
  autoload :DomainKwcountSem,         'sistrix/domain_kwcount_sem'

  SERVICE_HOST = 'api.sistrix.net'

  def self.domain(options = {})
    ::Sistrix::Domain.new.fetch(options)
  end

  def self.domain_sichtbarkeitsindex(options = {})
    ::Sistrix::DomainSichtbarkeitsindex.new.fetch(options)
  end

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
