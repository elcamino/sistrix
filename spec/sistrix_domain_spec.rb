# encoding: utf-8

require 'spec_helper'
require 'sistrix'
require 'pp'

WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')
domain   = 'zeit.de'
keyword  = 'auto'

#
# Sistrix.domain()
#

describe "Sistrix.domain(:domain => '#{domain}') returns a list of available domain API calls for the given domain" do

  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.xml')))
    Sistrix.domain(:domain => domain)
  }

  it { should be }

  its(:credits) { should == 0 }
  its(:"options.size") { should == 11 }

  it "domain.sichtbarkeitsindex" do
    subject.options.find { |o| o.method == 'domain.sichtbarkeitsindex' }.should be
  end

  it "domain.pagerank" do
    subject.options.find { |o| o.method == 'domain.pagerank' }.should be
  end

  it "domain.pages" do
    subject.options.find { |o| o.method == 'domain.pages' }.should be
  end

  it "domain.age" do
    subject.options.find { |o| o.method == 'domain.age' }.should be
  end

  it "domain.kwcount.seo" do
    subject.options.find { |o| o.method == 'domain.kwcount.seo' }.should be
  end

  it "domain.kwcount.sem" do
    subject.options.find { |o| o.method == 'domain.kwcount.sem' }.should be
  end

  it "domain.social.overview" do
    subject.options.find { |o| o.method == 'domain.social.overview' }.should be
  end

  it "domain.social.url" do
    subject.options.find { |o| o.method == 'domain.social.url' }.should be
  end

  it "domain.social.top" do
    subject.options.find { |o| o.method == 'domain.social.top' }.should be
  end

  it "domain.social.latest" do
    subject.options.find { |o| o.method == 'domain.social.latest' }.should be
  end
end

#
# Sistrix.domain_overview
#

describe "Sistrix.domain_overview(:domain => '#{domain}') returns an overview of the domain" do

  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.overview?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.overview.xml')))
    Sistrix.domain_overview(:domain => domain)
  }

  it { should be }

  its(:credits) { should == 6 }

  its(:age) { should be }
  its(:"age.domain") { should == domain }
  its(:"age.date") { should be_nil }
  its(:"age.value") { should == Time.parse('1998-02-13T00:00:00+01:00') }

  its(:kwcount_sem) { should be }
  its(:"kwcount_sem.domain") { should == domain }
  its(:"kwcount_sem.date") { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its(:"kwcount_sem.value") { should == 15 }

  its(:kwcount_seo) { should be }
  its(:"kwcount_seo.domain") { should == domain }
  its(:"kwcount_seo.date") { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its(:"kwcount_seo.value") { should ==  85893 }

  its(:pagerank) { should be }
  its(:"pagerank.domain") { should == domain }
  its(:"pagerank.date") { should == Time.parse('2009-04-11T00:00:00+02:00') }
  its(:"pagerank.value") {  should == 8 }

  its(:pages) { should be }
  its(:"pages.domain") { should == domain }
  its(:"pages.date") { should == Time.parse('2012-04-11T00:00:00+02:00') }
  its(:"pages.value") {  should == 3710000 }

  its(:sichtbarkeitsindex) { should be }
  its(:"sichtbarkeitsindex.domain") { should == domain }
  its(:"sichtbarkeitsindex.date") { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its(:"sichtbarkeitsindex.value") {  should == 108.6181 }


end

#
# Sistrix.domain_pages()
#

describe "Sistrix.domain_pages(:domain => '#{domain}', :history => [true|false]) returns the number of pages in the index" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.pages?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.pages.xml')))
     Sistrix.domain_pages(:domain => domain)
  }

  it { should be }

  its(:credits) { should == 1 }

  its(:pages) { should be }
  its(:"pages.size") { should == 1 }

  it "pages[0] exists" do
    subject.pages[0].should be
  end

  it "pages[0].domain == #{domain}" do
    subject.pages[0].domain.should == domain
  end

  it "pages[0].value == 3710000" do
    subject.pages[0].value.should == 3710000
  end

  it "pages[0].date == 2012-04-11T00:00:00+02:00" do
    subject.pages[0].date.should == Time.parse('2012-04-11T00:00:00+02:00')
  end
end

#
# Sistrix.domain_pagerank()
#

describe "Sistrix.domain_pagerank(:domain => '#{domain}', :history => [true|false]) returns the pagerank of the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.pagerank?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.pagerank.xml')))
    Sistrix.domain_pagerank(:domain => domain)
  }

  it { should be }

  its(:credits) { should == 1 }

  its(:pageranks) { should be }
  its(:"pageranks.size") { should == 1 }

  it "pageranks[0].domain == #{domain}" do
    subject.pageranks[0].domain.should == domain
  end

  it "pageranks[0].date == 2009-04-11T00:00:00+02:00" do
    subject.pageranks[0].date.should == Time.parse('2009-04-11T00:00:00+02:00')
  end

  it "pageranks[0].value == 8" do
    subject.pageranks[0].value.should == 8
  end

end

#
# Sistrix.domain_age()
#

describe "Sistrix.domain_age(:domain => '#{domain}') returns the age of the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.age?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.age.xml')))
    res = Sistrix.domain_age(:domain => domain)
  }

  its(:credits) { should == 1 }
  its(:age) { should == Time.parse('1998-02-13T00:00:00+01:00') }
  its(:domain) { should == domain }
end

#
# Sistrix.domain_kwcount_sem()
#

describe "Sistrix.domain_kwcount_sem(:domain => '#{domain}', :history => [true|false]) returns the number of SEM keywords for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.kwcount.sem?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.kwcount.sem.xml')))
    Sistrix.domain_kwcount_sem(:domain => domain)
  }

  its(:credits) { should == 1 }
  its('kwcount.size') { should == 1 }

  its('kwcount.first.domain') { should == domain }
  its('kwcount.first.date') { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its('kwcount.first.value') { should == 15 }
end

#
# Sistrix.domain_kwcount_seo()
#

describe "Sistrix.domain_kwcount_seo(:domain => '#{domain}', :history => [true|false]) returns the number of SEO keywords for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.kwcount.seo?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.kwcount.seo.xml')))
    res = Sistrix.domain_kwcount_seo(:domain => domain)
  }

  its(:credits) { should == 1 }
  its('kwcount.size') { should == 1 }

  its('kwcount.first.domain') { should == domain }
  its('kwcount.first.date') { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its('kwcount.first.value') { should == 85893 }
end

#
# Sistrix.domain_competitors_us
#

describe "Sistrix.domain_competitors_us(:domain => '#{domain}', :num => [number_of_results]) returns a list of Universal Search competitors for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.competitors.us?api_key=&domain=#{domain}&num=5").to_return(File.new(File.join(xml_base, 'domain.competitors.us.xml')))
    res = Sistrix.domain_competitors_us(:domain => domain, :num => 5)
  }

  its(:credits) { should == 5 }
  its("competitors.size") { should == 5 }

  describe "competitor youtube.com" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'youtube.com' } }

    it do
      comp.should be
    end

    it "domain should be 'youtube.com'" do
      comp.domain { should == 'youtube.com' }
    end

    it "match should be 100" do
      comp.match { should == 100 }
    end
  end

  describe "competitor wikimedia.org" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'wikimedia.org' } }

    it do
      comp.should be
    end

    it "domain should be 'wikimedia.org'" do
      comp.domain { should == 'wikimedia.org' }
    end

    it "match should be 65" do
      comp.match { should == 65 }
    end
  end

  describe "competitor focus.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'focus.de' } }

    it do
      comp.should be
    end

    it "domain should be 'focus.de'" do
      comp.domain { should == 'focus.de' }
    end

    it "match should be 43" do
      comp.match { should == 43 }
    end
  end

  describe "competitor welt.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'welt.de' } }

    it do
      comp.should be
    end

    it "domain should be 'welt.de'" do
      comp.domain { should == 'welt.de' }
    end

    it "match should be 19" do
      comp.match { should == 19 }
    end
  end

  describe "competitor bild.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'bild.de' } }

    it do
      comp.should be
    end

    it "domain should be 'bild.de'" do
      comp.domain { should == 'bild.de' }
    end

    it "match should be 18" do
      comp.match { should == 18 }
    end
  end

end

#
# Sistrix.domain_competitors_sem
#

describe "Sistrix.domain_competitors_sem(:domain => '#{domain}', :num => [number_of_results]) returns a list of SEM competitors for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.competitors.sem?api_key=&domain=#{domain}&num=5").to_return(File.new(File.join(xml_base, 'domain.competitors.sem.xml')))
    Sistrix.domain_competitors_sem(:domain => domain, :num => 5)
  }

  its(:credits) { should == 5 }
  its("competitors.size") { should == 5 }

  describe "competitor stepstone.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'stepstone.de' } }

    it do
      comp.should be
    end

    it "domain should be 'stepstone.de'" do
      comp.domain { should == 'stepstone.de' }
    end

    it "match should be 100" do
      comp.match { should == 100 }
    end
  end

  describe "competitor jobscout24.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'jobscout24.de' } }

    it do
      comp.should be
    end

    it "domain should be 'jobscout24.de'" do
      comp.domain { should == 'jobscout24.de' }
    end

    it "match should be 49" do
      comp.match { should == 49 }
    end
  end

  describe "competitor monster.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'monster.de' } }

    it do
      comp.should be
    end

    it "domain should be 'monster.de'" do
      comp.domain { should == 'monster.de' }
    end

    it "match should be 48" do
      comp.match { should == 48 }
    end
  end

  describe "competitor caritas.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'caritas.de' } }

    it do
      comp.should be
    end

    it "domain should be 'caritas.de'" do
      comp.domain { should == 'caritas.de' }
    end

    it "match should be 37" do
      comp.match { should == 37 }
    end
  end

  describe "competitor fazjob.net" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'fazjob.net' } }

    it do
      comp.should be
    end

    it "domain should be 'fazjob.net'" do
      comp.domain { should == 'fazjob.net' }
    end

    it "match should be 29" do
      comp.match { should == 29 }
    end
  end

end

#
# Sistrix.domain_competitors_seo
#

describe "Sistrix.domain_competitors_seo(:domain => '#{domain}', :num => [number_of_results]) returns a list of SEO competitors for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.competitors.seo?api_key=&domain=#{domain}&num=5").to_return(File.new(File.join(xml_base, 'domain.competitors.seo.xml')))
    Sistrix.domain_competitors_seo(:domain => domain, :num => 5)
  }

  its(:credits) { should == 5 }
  its("competitors.size") { should == 5 }

  describe "competitor facebook.com" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'facebook.com' } }

    it do
      comp.should be
    end

    it "domain should be 'facebook.com'" do
      comp.domain { should == 'facebook.com' }
    end

    it "match should be 100" do
      comp.match { should == 100 }
    end
  end

  describe "competitor amazon.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'amazon.de' } }

    it do
      comp.should be
    end

    it "domain should be 'amazon.de'" do
      comp.domain { should == 'amazon.de' }
    end

    it "match should be 87" do
      comp.match { should == 87 }
    end
  end

  describe "competitor spiegel.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'spiegel.de' } }

    it do
      comp.should be
    end

    it "domain should be 'spiegel.de'" do
      comp.domain { should == 'spiegel.de' }
    end

    it "match should be 54" do
      comp.match { should == 54 }
    end
  end

  describe "competitor focus.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'focus.de' } }

    it do
      comp.should be
    end

    it "domain should be 'focus.de'" do
      comp.domain { should == 'focus.de' }
    end

    it "match should be 50" do
      comp.match { should == 50 }
    end
  end

  describe "competitor welt.de" do
    let(:comp) { subject.competitors.find { |c| c.domain == 'welt.de' } }

    it do
      comp.should be
    end

    it "domain should be 'welt.de'" do
      comp.domain { should == 'welt.de' }
    end

    it "match should be 38" do
      comp.match { should == 38 }
    end
  end

end

#
# Sistrix.domain_sichtbarkeitsindex
#

describe "Sistrix.domain_sichtbarkeitsindex(:domain => '#{domain}', :history => [true|false]) returns the Sichtbarkeitsindex for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.sichtbarkeitsindex?api_key=&domain=#{domain}&history=").to_return(File.new(File.join(xml_base, 'domain.sichtbarkeitsindex.xml')))
    Sistrix.domain_sichtbarkeitsindex(:domain => domain)
  }

  its(:credits) { should == 1 }
  its("sichtbarkeitsindex.size") { should == 1 }
  its("sichtbarkeitsindex.first.domain") { should == domain }
  its("sichtbarkeitsindex.first.date") { should ==  Time.parse('2012-04-09T00:00:00+02:00') }
  its("sichtbarkeitsindex.first.value") { should == 108.6181 }
end

#
# Sistrix.domain_social_overview
#

describe "Sistrix.domain_social_overview(:domain => '#{domain}') returns the social network stats for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.overview?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'domain.social.overview.xml')))
    Sistrix.domain_social_overview(:domain => domain)
  }

  its(:credits) { should == 3 }
  its(:twitter) { should == 557071 }
  its(:facebook) { should == 1335512 }
  its(:googleplus) { should == 27531 }
end

#
# Sistrix.domain_social_top
#

describe "Sistrix.domain_social_top(:domain => '#{domain}', :network => [facebook|twitter|googleplus], :num => [number_of_results]) returns a list of the urls with the most social network votes for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.top?api_key=&domain=#{domain}&network=&num=10").to_return(File.new(File.join(xml_base, 'domain.social.top.xml')))
    Sistrix.domain_social_top(:domain => domain, :num => 10)
  }

  its(:credits) { should == 10 }

  its("urls.size") { should == 10 }

  describe "url 'http://www.zeit.de/datenschutz/malte-spitz-vorratsdaten'" do
    let (:url) { subject.urls.find { |u| u.url == 'http://www.zeit.de/datenschutz/malte-spitz-vorratsdaten' } }

    it "should be" do
      url.should be
    end

    it "votes should be 109822" do
      url.votes.should == 109822
    end

    it "network should be 'total'" do
      url.network.should == 'total'
    end
  end


  describe "url 'http://www.zeit.de/2011/22/DOS-G8'" do
    let (:url) { subject.urls.find { |u| u.url == 'http://www.zeit.de/2011/22/DOS-G8' } }

    it "should be" do
      url.should be
    end

    it "votes should be 82933" do
      url.votes.should == 82933
    end

    it "network should be 'total'" do
      url.network.should == 'total'
    end
  end

end

#
# Sistrix.domain_social_latest
#

describe "Sistrix.domain_social_latest(:domain => '#{domain}', :network => [facebook|twitter|googleplus], :num => [number_of_results]) returns a list of the most recent urls that have received a social network vote for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.latest?api_key=&domain=#{domain}&network=&num=10").to_return(File.new(File.join(xml_base, 'domain.social.latest.xml')))
    Sistrix.domain_social_latest(:domain => domain, :num => 10)
  }

  its(:credits) { should == 10 }

  its("urls.size") { should == 10 }

  describe "url 'http://www.zeit.de/2011/38/P-Fahrrad'" do
    let (:url) { subject.urls.find { |u| u.url == 'http://www.zeit.de/2011/38/P-Fahrrad' } }

    it "should be" do
      url.should be
    end

    it "date should be 2012-04-10T14:29:42+02:00" do
      url.date.should == Time.parse('2012-04-10T14:29:42+02:00')
    end
  end


  describe "url 'http://www.zeit.de/politik/2012-04/grass-gedicht-israel-debatte'" do
    let (:url) { subject.urls.find { |u| u.url == 'http://www.zeit.de/politik/2012-04/grass-gedicht-israel-debatte' } }

    it "should be" do
      url.should be
    end

    it "date should be 2012-04-10T15:51:23+02:00" do
      url.date.should == Time.parse('2012-04-10T15:51:23+02:00')
    end

  end
end

describe "Sistrix.domain_social_url(:domain => '#{domain}', :history => [true|false]) returns a list of social network votes for one url of the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/domain.social.url?api_key=&domain=#{domain}&history=true").to_return(File.new(File.join(xml_base, 'domain.social.url_with_history.xml')))
    Sistrix.domain_social_url(:domain => domain, :history => true)
  }

  its(:credits) { should == 3 }
  its(:url) { should == 'http://www.zeit.de/2011/38/P-Fahrrad' }
  its(:total) { should == 408 }
  its(:facebook) { should == 260 }
  its(:twitter) { should == 144 }
  its(:googleplus) { should == 4 }
  its("history.size") { should == 2 }

  describe "history[0]" do
    let(:history) { subject.history[0] }

    it "should be" do
      history.should be
    end

    it "date should be '2012-04-11T16:56:19+02:00'" do
      history.date.should == Time.parse('2012-04-11T16:56:19+02:00')
    end

    it "total should be 408" do
      history.total.should == 408
    end

    it "facebook should be 260" do
      history.facebook.should == 260
    end

    it "twitter should be 144" do
      history.twitter.should == 144
    end

    it "googleplus should be 4" do
      history.googleplus.should == 4
    end
  end

end
