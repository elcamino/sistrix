# encoding: utf-8

require 'spec_helper'
require 'sistrix'
require 'pp'

WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')
domain   = 'zeit.de'
keyword  = 'auto'

describe "Sistrix" do

#  let(:domain) { 'zeit.de' }

  it "domain(:domain => '#{domain}') returns a list of available domain API calls for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.xml')))
    res = Sistrix.domain(:domain => domain)

    #
    # credits
    #
    res.credits.should == 0

    #
    # options
    #

    # 11 results
    res.options.size.should == 11

    # is every option in the list?
    res.options.find { |o| o.method == 'domain.sichtbarkeitsindex' }.should be
    res.options.find { |o| o.method == 'domain.overview' }.should be
    res.options.find { |o| o.method == 'domain.pagerank' }.should be
    res.options.find { |o| o.method == 'domain.pages' }.should be
    res.options.find { |o| o.method == 'domain.age' }.should be
    res.options.find { |o| o.method == 'domain.kwcount.seo' }.should be
    res.options.find { |o| o.method == 'domain.kwcount.sem' }.should be
    res.options.find { |o| o.method == 'domain.social.overview' }.should be
    res.options.find { |o| o.method == 'domain.social.url' }.should be
    res.options.find { |o| o.method == 'domain.social.top' }.should be
    res.options.find { |o| o.method == 'domain.social.latest' }.should be
  end

  it "domain_overview(:domain => '#{domain}') returns an overview of the domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.overview?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.overview.xml')))
    res = Sistrix.domain_overview(:domain => domain)

    #
    # credits
    #
    res.credits.should == 6

    #
    # age
    #
    res.age.should be
    res.age.domain.should == domain
    res.age.date.should be_nil
    res.age.value.should == Time.parse('1998-02-13T00:00:00+01:00')

    #
    # kwcount_sem
    #
    res.kwcount_sem.should be
    res.kwcount_sem.domain.should == domain
    res.kwcount_sem.date.should == Time.parse('2012-04-09T00:00:00+02:00')
    res.kwcount_sem.value.should == 15

    #
    # kwcount_seo
    #
    res.kwcount_seo.should be
    res.kwcount_seo.domain.should == domain
    res.kwcount_seo.date.should == Time.parse('2012-04-09T00:00:00+02:00')
    res.kwcount_seo.value.should == 85893

    #
    # pagerank
    #
    res.pagerank.should be
    res.pagerank.domain.should == domain
    res.pagerank.date.should == Time.parse('2009-04-11T00:00:00+02:00')
    res.pagerank.value.should == 8

    #
    # pages
    #
    res.pages.should be
    res.pages.domain.should == domain
    res.pages.date.should == Time.parse('2012-04-11T00:00:00+02:00')
    res.pages.value.should == 3710000

    #
    # sichtbarkeitsindex
    #
    res.sichtbarkeitsindex.should be
    res.sichtbarkeitsindex.domain.should == domain
    res.sichtbarkeitsindex.date.should == Time.parse('2012-04-09T00:00:00+02:00')
    res.sichtbarkeitsindex.value.should == 108.6181

  end

  it "domain_pages(:domain => '#{domain}', :history => [true|false]) returns the number of pages in the index" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.pages?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.pages.xml')))
    res = Sistrix.domain_pages(:domain => domain)

    #
    # credits
    #
    res.credits.should == 1

    #
    # pages
    #
    res.pages.size.should == 1

    res.pages[0].domain.should == domain
    res.pages[0].value.should == 3710000
    res.pages[0].date.should == Time.parse('2012-04-11T00:00:00+02:00')

  end



  it "domain_pagerank(:domain => '#{domain}', :history => [true|false]) returns the pagerank of the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.pagerank?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.pagerank.xml')))
    res = Sistrix.domain_pagerank(:domain => domain)


    #
    # credits
    #
    res.credits.should == 1

    #
    # pagerank
    #
    res.pageranks.size.should == 1
    res.pageranks[0].domain.should == domain
    res.pageranks[0].date.should == Time.parse('2009-04-11T00:00:00+02:00')
    res.pageranks[0].value.should == 8

  end

  it "domain_age(:domain => '#{domain}') returns the age of the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.age?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.age.xml')))
    res = Sistrix.domain_age(:domain => domain)


    #
    # credits
    #
    res.credits.should == 1

    #
    # age
    #
    res.age.should == Time.parse('1998-02-13T00:00:00+01:00')
    res.domain.should == domain
  end

  it "domain_kwcount_sem(:domain => '#{domain}', :history => [true|false]) returns the number of SEM keywords for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.kwcount.sem?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.kwcount.sem.xml')))
    res = Sistrix.domain_kwcount_sem(:domain => domain)


    #
    # credits
    #
    res.credits.should == 1

    #
    # kwcount
    #
    res.kwcount.size.should == 1
    res.kwcount[0].domain.should == domain
    res.kwcount[0].date.should == Time.parse('2012-04-09T00:00:00+02:00')
    res.kwcount[0].value.should == 15
  end

  it "domain_kwcount_seo(:domain => '#{domain}', :history => [true|false]) returns the number of SEO keywords for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.kwcount.seo?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.kwcount.seo.xml')))
    res = Sistrix.domain_kwcount_seo(:domain => domain)


    #
    # credits
    #
    res.credits.should == 1

    #
    # kwcount
    #
    res.kwcount.size.should == 1
    res.kwcount[0].domain.should == domain
    res.kwcount[0].date.should == Time.parse('2012-04-09T00:00:00+02:00')
    res.kwcount[0].value.should == 85893
  end


  it "domain_competitors_us(:domain => '#{domain}', :num => [number_of_results]) returns a list of Universal Search competitors for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.competitors.us?api_key=&domain=#{domain}&num=5").to_return(File.new(File.join(xml_base, 'domain.competitors.us.xml')))
    res = Sistrix.domain_competitors_us(:domain => domain, :num => 5)


    #
    # credits
    #
    res.credits.should == 5

    #
    # competitors
    #
    res.competitors.size.should == 5

    youtube = res.competitors.find { |c| c.domain == 'youtube.com'}
    youtube.should be
    youtube.domain.should == 'youtube.com'
    youtube.match.should == 100

    wikimedia = res.competitors.find { |c| c.domain == 'wikimedia.org'}
    wikimedia.should be
    wikimedia.domain.should == 'wikimedia.org'
    wikimedia.match.should == 65

    focus = res.competitors.find { |c| c.domain == 'focus.de'}
    focus.should be
    focus.domain.should == 'focus.de'
    focus.match.should == 43

    welt = res.competitors.find { |c| c.domain == 'welt.de'}
    welt.should be
    welt.domain.should == 'welt.de'
    welt.match.should == 19

    bild = res.competitors.find { |c| c.domain == 'bild.de'}
    bild.should be
    bild.domain.should == 'bild.de'
    bild.match.should == 18


  end

  it "domain_competitors_sem(:domain => '#{domain}', :num => [number_of_results]) returns a list of SEM competitors for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.competitors.sem?api_key=&domain=#{domain}&num=5").to_return(File.new(File.join(xml_base, 'domain.competitors.sem.xml')))
    res = Sistrix.domain_competitors_sem(:domain => domain, :num => 5)


    #
    # credits
    #
    res.credits.should == 5

    #
    # competitors
    #
    res.competitors.size.should == 5

    c = res.competitors.find { |c| c.domain == 'stepstone.de'}
    c.should be
    c.domain.should == 'stepstone.de'
    c.match.should == 100
    c = nil

    c = res.competitors.find { |c| c.domain == 'jobscout24.de'}
    c.should be
    c.domain.should == 'jobscout24.de'
    c.match.should == 49
    c = nil

    c = res.competitors.find { |c| c.domain == 'monster.de'}
    c.should be
    c.domain.should == 'monster.de'
    c.match.should == 48
    c = nil

    c = res.competitors.find { |c| c.domain == 'caritas.de'}
    c.should be
    c.domain.should == 'caritas.de'
    c.match.should == 37
    c = nil

    c = res.competitors.find { |c| c.domain == 'fazjob.net'}
    c.should be
    c.domain.should == 'fazjob.net'
    c.match.should == 29
    c = nil


  end

  it "domain_competitors_seo(:domain => '#{domain}', :num => [number_of_results]) returns a list of SEO competitors for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.competitors.seo?api_key=&domain=#{domain}&num=5").to_return(File.new(File.join(xml_base, 'domain.competitors.seo.xml')))
    res = Sistrix.domain_competitors_seo(:domain => domain, :num => 5)


    #
    # credits
    #
    res.credits.should == 5

    #
    # competitors
    #
    res.competitors.size.should == 5

    c = res.competitors.find { |c| c.domain == 'facebook.com'}
    c.should be
    c.domain.should == 'facebook.com'
    c.match.should == 100
    c = nil

    c = res.competitors.find { |c| c.domain == 'amazon.de'}
    c.should be
    c.domain.should == 'amazon.de'
    c.match.should == 87
    c = nil

    c = res.competitors.find { |c| c.domain == 'spiegel.de'}
    c.should be
    c.domain.should == 'spiegel.de'
    c.match.should == 54
    c = nil

    c = res.competitors.find { |c| c.domain == 'focus.de'}
    c.should be
    c.domain.should == 'focus.de'
    c.match.should == 50
    c = nil

    c = res.competitors.find { |c| c.domain == 'welt.de'}
    c.should be
    c.domain.should == 'welt.de'
    c.match.should == 38
    c = nil
  end

  it "domain_sichtbarkeitsindex(:domain => '#{domain}', :history => [true|false]) returns the Sichtbarkeitsindex for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.sichtbarkeitsindex?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.sichtbarkeitsindex.xml')))
    res = Sistrix.domain_sichtbarkeitsindex(:domain => domain)


    #
    # credits
    #
    res.credits.should == 1

    #
    # sichtbarkeitsindex
    #
    res.sichtbarkeitsindex.size.should == 1
    res.sichtbarkeitsindex[0].domain.should == domain
    res.sichtbarkeitsindex[0].date.should == Time.parse('2012-04-09T00:00:00+02:00')
    res.sichtbarkeitsindex[0].value.should == 108.6181

  end

  it "domain_social_overview(:domain => '#{domain}') returns the social network stats for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.overview?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.social.overview.xml')))
    res = Sistrix.domain_social_overview(:domain => domain)

    res.credits.should == 3
    res.twitter.should == 557071
    res.facebook.should == 1335512
    res.googleplus.should == 27531
  end

  it "domain_social_top(:domain => '#{domain}', :network => [facebook|twitter|googleplus], :num => [number_of_results]) returns a list of the urls with the most social network votes for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.top?api_key=&domain=#{domain}&network=&num=10").to_return(File.new(File.join(xml_base, 'domain.social.top.xml')))
    res = Sistrix.domain_social_top(:domain => domain, :num => 10)

    #
    # credits
    #
    res.credits.should == 10

    #
    # urls
    #
    res.urls.size.should == 10

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/datenschutz/malte-spitz-vorratsdaten' }
    u.should be
    u.votes.should == 109822
    u.network.should == 'total'
    u = nil

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/2011/22/DOS-G8' }
    u.should be
    u.votes.should == 82933
    u.network.should == 'total'
    u = nil

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/datenschutz/malte-spitz-data-retention' }
    u.should be
    u.votes.should == 36029
    u.network.should == 'total'
    u = nil

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/datenschutz/malte-spitz-vorratsdaten/' }
    u.should be
    u.votes.should == 28329
    u.network.should == 'total'
    u = nil


  end

  it "domain_social_latest(:domain => '#{domain}', :network => [facebook|twitter|googleplus], :num => [number_of_results]) returns a list of the most recent urls that have received a social network vote for the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.latest?api_key=&domain=#{domain}&network=&num=10").to_return(File.new(File.join(xml_base, 'domain.social.latest.xml')))
    res = Sistrix.domain_social_latest(:domain => domain, :num => 10)

    #
    # credits
    #
    res.credits.should == 10

    #
    # urls
    #
    res.urls.size.should == 10

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/2011/38/P-Fahrrad' }
    u.should be
    u.date.should == Time.parse('2012-04-10T14:29:42+02:00')
    u = nil

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/politik/2012-04/grass-gedicht-israel-debatte' }
    u.should be
    u.date.should == Time.parse('2012-04-10T15:51:23+02:00')
    u = nil

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/lebensart/2012-04/fs-baumeister-der-revolution-5' }
    u.should be
    u.date.should == Time.parse('2012-04-10T15:49:53+02:00')
    u = nil

    u = res.urls.find { |u| u.url == 'http://www.zeit.de/kultur/film/2012-04/work-hard-film' }
    u.should be
    u.date.should == Time.parse('2012-04-10T19:57:55+02:00')
    u = nil

  end

  it "domain_social_url(:domain => '#{domain}', :history => [true|false]) returns a list of social network votes for one url of the given domain" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.url?api_key=&domain=#{domain}&history=true").to_return(File.new(File.join(xml_base, 'domain.social.url_with_history.xml')))
    res = Sistrix.domain_social_url(:domain => domain, :history => true)

    #
    # credits
    #
    res.credits.should == 3

    res.url.should == 'http://www.zeit.de/2011/38/P-Fahrrad'
    res.total.should == 408
    res.facebook.should == 260
    res.twitter.should == 144
    res.googleplus.should == 4


    #
    # urls
    #
    res.history.size.should == 2

    res.history[0].date.should == Time.parse('2012-04-11T16:56:19+02:00')
    res.history[0].total.should == 408
    res.history[0].facebook.should == 260
    res.history[0].twitter.should == 144
    res.history[0].googleplus.should == 4

    res.history[1].date.should == Time.parse('2012-04-10T15:05:41+02:00')
    res.history[1].total.should == 408
    res.history[1].facebook.should == 260
    res.history[1].twitter.should == 144
    res.history[1].googleplus.should == 4
  end

  it "keyword(:kw => '[keyword]') returns a list of available API methods for the given keyword" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword?api_key=&kw=#{keyword}").to_return(File.new(File.join(xml_base, 'keyword.xml')))
    res = Sistrix.keyword(:kw => keyword)


    #
    # credits
    #
    res.credits.should == 0

    #
    # options
    #
    res.options.size.should == 3

    res.options[0].method.should == 'keyword.seo'
    res.options[0].url.should == 'http://api.sistrix.net/keyword.seo?api_key=&kw=auto'
    res.options[0].name.should == 'Organisches Ranking'

    res.options[1].method.should == 'keyword.sem'
    res.options[1].url.should == 'http://api.sistrix.net/keyword.sem?api_key=&kw=auto'
    res.options[1].name.should == 'Bezahlte Werbung'

    res.options[2].method.should == 'keyword.us'
    res.options[2].url.should == 'http://api.sistrix.net/keyword.us?api_key=&kw=auto'
    res.options[2].name.should == 'Universal Search-Integrationen'

  end

  it "keyword_seo(:kw => '[keyword]', :num => [number_of_results], :date => [date]) returns a SEO rank list of domains and URLs for the given keyword and date" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.seo?api_key=&date=last%20week&kw=#{keyword}&num=10&url=").to_return(File.new(File.join(xml_base, 'keyword.seo.xml')))
    res = Sistrix.keyword_seo(:kw => keyword, :num => 10, :date => 'last week')

    #
    # credits
    #
    res.credits.should == 10

    #
    # date
    #
    res.date.should == Time.parse('2012-04-02T00:00:00+02:00')

    #
    # results
    #
    res.results.size.should == 10

    r = res.results.find { |r| r.position == 1 }
    r.should be
    r.position.should == 1
    r.domain.should == 'auto.de'
    r.url.should == 'http://www.auto.de/'

    r = res.results.find { |r| r.position == 10 }
    r.should be
    r.position.should == 10
    r.domain.should == 'bmw.de'
    r.url.should == 'http://www.bmw.de/'

  end

  it "keyword_seo(:kw => '[keyword]', :num => [number_of_results], :date => [date], :url => [url]) returns the current SEO position for the given keyword, date and url" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.seo?api_key=&date=last%20week&kw=#{keyword}&num=10&url=http://www.autobild.de/").to_return(File.new(File.join(xml_base, 'keyword.seo_with_url.xml')))
    res = Sistrix.keyword_seo(:kw => keyword, :num => 10, :date => 'last week', :url => 'http://www.autobild.de/')

    #
    # credits
    #
    res.credits.should == 1

    #
    # date
    #
    res.date.should == Time.parse('2012-04-02T00:00:00+02:00')

    #
    # results
    #
    res.results.size.should == 1

    r = res.results[0]
    r.should be
    r.position.should == 4
    r.domain.should == 'autobild.de'
    r.url.should == 'http://www.autobild.de/'
  end

  it "keyword_sem(:kw => '[keyword]', :num => [number_of_results], :date => [date]) returns a list of SEM bookings for the given keyword and date" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.sem?api_key=&date=now&domain=&kw=#{keyword}&num=3").to_return(File.new(File.join(xml_base, 'keyword.sem.xml')))
    res = Sistrix.keyword_sem(:kw => keyword, :num => 3, :date => 'now')

    #
    # credits
    #
    res.credits.should == 3

    #
    # date
    #
    res.date.should == Time.parse('2012-04-09T00:00:00+02:00')

    #
    # results
    #
    r = res.results[0]
    r.should be
    r.position.should == 1
    r.title.should == 'mobile.de - Deutschlands größter Fahrzeugmarkt.'
    r.text.should == 'Welcher ist dein Nächster?  Geprüfte Gebrauchtwagen - Günstige Jahreswagen - Neuwagen - Limousine'
    r.displayurl.should == 'www.mobile.de/'

  end

  it "keyword_sem(:kw => '[keyword]', :num => [number_of_results], :date => [date], :domain => [domain]) returns a list of SEM bookings for the given keyword, domain and date" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.sem?api_key=&date=now&domain=mobile.de&kw=#{keyword}&num=3").to_return(File.new(File.join(xml_base, 'keyword.sem_with_domain2.xml')))
    res = Sistrix.keyword_sem(:kw => keyword, :num => 3, :date => 'now', :domain => 'mobile.de')

    #
    # credits
    #
    res.credits.should == 1

    #
    # date
    #
    res.date.should == Time.parse('2012-04-09T00:00:00+02:00')

    #
    # results
    #
    r = res.results[0]
    r.should be
    r.position.should == 1
    r.title.should == 'mobile.de - Deutschlands größter Fahrzeugmarkt.'
    r.text.should == 'Welcher ist dein Nächster?  Geprüfte Gebrauchtwagen - Günstige Jahreswagen - Neuwagen - Limousine'
    r.displayurl.should == 'www.mobile.de/'

  end

  it "keyword_us(:kw => '[keyword]', :date => [date]) returns a list of Universal Search integration for the given keyword and date" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.us?api_key=&date=now&kw=angela+merkel").to_return(File.new(File.join(xml_base, 'keyword.us.xml')))
    res = Sistrix.keyword_us(:kw => 'angela merkel', :date => 'now')

    #
    # credits
    #
    res.credits.should == 9

    #
    # date
    #
    res.date.should == Time.parse('2012-04-09T00:00:00+02:00')

    #
    # results
    #
    res.results.size.should == 9

    r = res.results[0]
    r.should be
    r.type.should == 'x'
    r.position.should == 6
    r.position_intern.should == 'x'
    r.url.should == 'hxxxx//xxxxxxxxxx.xxxxx.xxxxxxxxx.xxx/xxxx/xx/xxxxxx-xxxxxxx.xxx'

  end


  it "keyword_domain_seo(:kw => '[keyword]', :date => [date], :domain => [domain], :num => [number_of_results]) returns a list of keyword rankings for the given domain and date" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.domain.seo?api_key=&date=now&domain=mobile.de&from_pos=&host=&num=5&path=&search=&to_pos=&url=").to_return(File.new(File.join(xml_base, 'keyword.domain.seo.xml')))
    res = Sistrix.keyword_domain_seo(:date => 'now', :domain => 'mobile.de', :num => 5)

    #
    # credits
    #
    res.credits.should == 5

    #
    # date
    #
    res.date.should == Time.parse('2012-04-09T00:00:00+02:00')

    #
    # results
    #
    res.results.size.should == 5

    r = res.results[0]
    r.should be
    r.kw.should == 'mobile'
    r.position.should == 1
    r.competition.should == 67
    r.traffic.should == 70
    r.url.should == 'http://suchen.mobile.de/fahrzeuge/auto/'

  end

  it "keyword_domain_sem(:date => [date], :domain => [domain], :num => [number_of_results]) returns a list of keywords with SEM bookings for the given domain and date" do
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.domain.us?api_key=&date=now&domain=mobile.de&num=5&search=").to_return(File.new(File.join(xml_base, 'keyword.domain.us.xml')))
    res = Sistrix.keyword_domain_us(:date => 'now', :domain => 'mobile.de', :num => 5)

    #
    # credits
    #
    res.credits.should == 5

    #
    # date
    #
    res.date.should == Time.parse('2012-01-16T00:00:00+01:00')

    #
    # results
    #
    res.results.size.should == 5

    r = res.results[0]
    r.should be
    r.kw.should == 'hxxxxxxx xxxxxxxx'
    r.type.should == 'x'
    r.position.should == 'x'
    r.position_intern.should == 'x'
    r.competition.should == 'xx'
    r.traffic.should == 'xx'
  end

end
