require 'spec_helper'
require 'sistrix'
require 'pp'

WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')



describe "Sistrix API" do

  let(:domain) { 'zeit.de' }

  it "domain() returns a list of available domain API calls for the given domain" do
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

  it "domain_pages() returns the number of pages in the index" do
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

  it "domain_overview() returns an overview of the domain" do
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
end
