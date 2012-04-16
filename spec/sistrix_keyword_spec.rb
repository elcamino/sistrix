# encoding: utf-8

require 'spec_helper'
require 'sistrix'

WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')
domain   = 'zeit.de'
keyword  = 'auto'


describe "Sistrix.keyword(:kw => '[keyword]') returns a list of available API methods for the given keyword" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword?api_key=&kw=#{keyword}").to_return(File.new(File.join(xml_base, 'keyword.xml')))
    Sistrix.keyword(:kw => keyword)
  }

  its(:credits) { should == 0 }
  its("options.size") { should == 3}

  describe "options[0]" do
    let(:option) { subject.options[0] }

    it "should be" do
      option.should be
    end

    it "method should be 'keyword.seo'" do
      option.method.should == 'keyword.seo'
    end

    it "url should be 'http://api.sistrix.net/keyword.seo?api_key=&kw=auto'" do
      option.url.should == 'http://api.sistrix.net/keyword.seo?api_key=&kw=auto'
    end

    it "name should be 'Organisches Ranking'" do
      option.name.should == 'Organisches Ranking'
    end
  end

  describe "options[1]" do
    let(:option) { subject.options[1] }

    it "should be" do
      option.should be
    end

    it "method should be 'keyword.sem'" do
      option.method.should == 'keyword.sem'
    end

    it "url should be 'http://api.sistrix.net/keyword.sem?api_key=&kw=auto'" do
      option.url.should == 'http://api.sistrix.net/keyword.sem?api_key=&kw=auto'
    end

    it "name should be 'Bezahlte Werbung'" do
      option.name.should == 'Bezahlte Werbung'
    end
  end

  describe "options[2]" do
    let(:option) { subject.options[2] }

    it "should be" do
      option.should be
    end

    it "method should be 'keyword.us'" do
      option.method.should == 'keyword.us'
    end

    it "url should be 'http://api.sistrix.net/keyword.us?api_key=&kw=auto'" do
      option.url.should == 'http://api.sistrix.net/keyword.us?api_key=&kw=auto'
    end

    it "name should be 'Universal Search-Integrationen'" do
      option.name.should == 'Universal Search-Integrationen'
    end
  end
end

describe "Sistrix.keyword_seo(:kw => '[keyword]', :num => [number_of_results], :date => [date]) returns a SEO rank list of domains and URLs for the given keyword and date" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.seo?api_key=&date=last%20week&kw=#{keyword}&num=10&url=").to_return(File.new(File.join(xml_base, 'keyword.seo.xml')))
    Sistrix.keyword_seo(:kw => keyword, :num => 10, :date => 'last week')
  }

  its(:credits) { should == 10 }
  its(:date) { should == Time.parse('2012-04-02T00:00:00+02:00') }
  its("results.size") { should == 10 }

  describe "results[0]" do
    let(:result) { subject.results[0] }

    it "should be" do
      result.should be
    end

    it "position should be 1" do
      result.position.should == 1
    end

    it "domain should be 'auto.de'" do
      result.domain.should == 'auto.de'
    end

    it "url should be 'http://www.auto.de/'" do
      result.url.should == 'http://www.auto.de/'
    end
  end

  describe "results[9]" do
    let(:result) { subject.results[9] }

    it "should be" do
      result.should be
    end

    it "position should be 10" do
      result.position.should == 10
    end

    it "domain should be 'bmw.de'" do
      result.domain.should == 'bmw.de'
    end

    it "url should be 'http://www.bmw.de/'" do
      result.url.should == 'http://www.bmw.de/'
    end
  end
end

describe "Sistrix.keyword_seo(:kw => '[keyword]', :num => [number_of_results], :date => [date], :url => [url]) returns the current SEO position for the given keyword, date and url" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.seo?api_key=&date=last%20week&kw=#{keyword}&num=10&url=http://www.autobild.de/").to_return(File.new(File.join(xml_base, 'keyword.seo_with_url.xml')))
    Sistrix.keyword_seo(:kw => keyword, :num => 10, :date => 'last week', :url => 'http://www.autobild.de/')
  }

  its(:credits) { should == 1 }
  its(:date) { should == Time.parse('2012-04-02T00:00:00+02:00') }
  its("results.size") { should == 1 }

  its("results.first") { should be }
  its("results.first.position") { should == 4 }
  its("results.first.domain") { should == 'autobild.de' }
  its("results.first.url") { should == 'http://www.autobild.de/' }
end

describe "Sistrix.keyword_sem(:kw => '[keyword]', :num => [number_of_results], :date => [date]) returns a list of SEM bookings for the given keyword and date" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.sem?api_key=&date=now&domain=&kw=#{keyword}&num=3").to_return(File.new(File.join(xml_base, 'keyword.sem.xml')))
    Sistrix.keyword_sem(:kw => keyword, :num => 3, :date => 'now')
  }

  its(:credits) { should == 3 }
  its(:date) { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its("results.size") { should == 3 }

  its("results.first.position") { should == 1 }
  its("results.first.title") { should == 'mobile.de - Deutschlands größter Fahrzeugmarkt.' }
  its("results.first.text") { should == 'Welcher ist dein Nächster?  Geprüfte Gebrauchtwagen - Günstige Jahreswagen - Neuwagen - Limousine' }
  its("results.first.displayurl") { should == 'www.mobile.de/' }
end

describe "Sistrix.keyword_us(:kw => '[keyword]', :date => [date]) returns a list of Universal Search integration for the given keyword and date" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.us?api_key=&date=now&kw=angela+merkel").to_return(File.new(File.join(xml_base, 'keyword.us.xml')))
    Sistrix.keyword_us(:kw => 'angela merkel', :date => 'now')
  }

  its(:credits) { should == 9 }
  its(:date) { should ==  Time.parse('2012-04-09T00:00:00+02:00') }
  its("results.size") { should == 9 }
  its("results.first.type") { should == 'x' }
  its("results.first.position") { should == 6 }
  its("results.first.position_intern") { should == 'x' }
  its("results.first.url") { should == 'hxxxx//xxxxxxxxxx.xxxxx.xxxxxxxxx.xxx/xxxx/xx/xxxxxx-xxxxxxx.xxx' }
end

describe "Sistrix.keyword_domain_seo(:kw => '[keyword]', :date => [date], :domain => [domain], :num => [number_of_results]) returns a list of keyword rankings for the given domain and date" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.domain.seo?api_key=&date=now&domain=mobile.de&from_pos=&host=&num=5&path=&search=&to_pos=&url=").to_return(File.new(File.join(xml_base, 'keyword.domain.seo.xml')))
    Sistrix.keyword_domain_seo(:date => 'now', :domain => 'mobile.de', :num => 5)
  }

  its(:credits) { should == 5 }
  its(:date) { should == Time.parse('2012-04-09T00:00:00+02:00') }
  its("results.size") { should == 5 }
  its("results.first.kw") { should == 'mobile' }
  its("results.first.position") { should == 1 }
  its("results.first.competition") { should == 67 }
  its("results.first.traffic") { should == 70 }
  its("results.first.url") { should == 'http://suchen.mobile.de/fahrzeuge/auto/' }
end

describe "Sistrix.keyword_domain_sem(:date => [date], :domain => [domain], :num => [number_of_results]) returns a list of keywords with SEM bookings for the given domain and date" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/keyword.domain.us?api_key=&date=now&domain=mobile.de&num=5&search=").to_return(File.new(File.join(xml_base, 'keyword.domain.us.xml')))
    Sistrix.keyword_domain_us(:date => 'now', :domain => 'mobile.de', :num => 5)
  }

  its(:credits) { should == 5 }
  its(:date) { should == Time.parse('2012-01-16T00:00:00+01:00') }
  its("results.size") { should == 5 }

  its("results.first.kw") { should == 'hxxxxxxx xxxxxxxx' }
  its("results.first.type") { should == 'x' }
  its("results.first.position") { should == 'x' }
  its("results.first.position_intern") { should == 'x' }
  its("results.first.competition") { should == 'xx' }
  its("results.first.traffic") { should == 'xx' }
end

