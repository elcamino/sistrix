# encoding: utf-8

require 'spec_helper'
require 'sistrix'

WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')
domain   = 'zeit.de'
keyword  = 'auto'



describe "Sistrix.links_overview(:domain => [domain]) returns an overview of the link statistics for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/links.overview?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'links.overview.xml')))
    Sistrix.links_overview(:domain => domain)
  }

  it { should be }

  its(:credits) { should be 25 }
  its(:total) { should be 2357268 }
  its(:hosts) { should be 84489 }
  its(:domains) { should be 51929 }
  its(:networks) { should be 28613 }
  its(:class_c) { should be 11878 }
end



describe "Sistrix.links_list(:domain => [domain]) returns the complete list of backlinks for the given domain" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/links.list?api_key=&domain=#{domain}").to_return(File.new(File.join(xml_base, 'links.list.xml')))
    Sistrix.links_list(:domain => domain)
  }

  it { should be }

  its(:credits) { should be 250 }

  its(:links) { should be }
  it { should have(10000).links }

  describe "links[0]" do
    let(:link) { subject.links[0] }

    it "url_from should be 'http://zeit-spiel.de/shop.html'" do
      link.url_from { should be 'http://zeit-spiel.de/shop.html' }
    end

    it "text should be 'About Time im DIE ZEIT Online Shop'" do
      link.text { should be 'About Time im DIE ZEIT Online Shop' }
    end

    it "url_to should be 'https://shop.zeit.de/category/745-DIE-ZEIT-Spiel-ABOUT-TIME'" do
      link.url_to { should be 'https://shop.zeit.de/category/745-DIE-ZEIT-Spiel-ABOUT-TIME' }
    end
  end

  describe "links[9999]" do
    let(:link) { subject.links[9999] }

    it "url_from should be 'http://mooszka.blogspot.com/2008/09/johnny-clarke-yard-style.html'" do
      link.url_from { should be 'http://mooszka.blogspot.com/2008/09/johnny-clarke-yard-style.html' }
    end

    it "text should be 'Zuender (D)'" do
      link.text { should be 'Zuender (D)' }
    end

    it "url_to should be 'http://zuender.zeit.de/'" do
      link.url_to { should be 'http://zuender.zeit.de/' }
    end
  end

end


describe "Sistrix.links_linktargets(:domain => [domain], :num => [number_of_results]) returns a list of pages with backlink statistics within the given domain" do
    subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/links.linktargets?api_key=&domain=#{domain}&num=").to_return(File.new(File.join(xml_base, 'links.linktargets.xml')))
    Sistrix.links_linktargets(:domain => domain)
  }

  it { should be }
  its(:credits) { should be 100 }
  its(:targets) { should be }
  it { should have(100).targets }

  describe "targets[0]" do
    let(:target) { subject.targets[0] }

    it "url should be 'http://zeit.de/'" do
      target.url { should be 'http://zeit.de/' }
    end

    it "links should be 4148" do
      target.links { should be 4148 }
    end

    it "hosts should be 321"  do
      target.hosts { should be 321 }
    end

    it "domains should be 230" do
      target.domains { should be 230 }
    end

    it "nets should be 185" do
      target.nets { should be 185 }
    end

    it "ips should be 204" do
      target.ips  { should be 204 }
    end
  end

  describe "targets[99]" do
    let(:target) { subject.targets[99] }

    it "url should be 'http://www.zeit.de/wissen/2011-08/depressionen-pille'" do
      target.url { should be 'http://www.zeit.de/wissen/2011-08/depressionen-pille' }
    end

    it "links should be 101" do
      target.links { should be 101 }
    end

    it "hosts should be 33"  do
      target.hosts { should be 33 }
    end

    it "domains should be 29" do
      target.domains { should be 29 }
    end

    it "nets should be 24" do
      target.nets { should be 24 }
    end

    it "ips should be 29" do
      target.ips  { should be 29 }
    end
  end

end


describe "Sistrix.links_linktexts(:domain => [domain], :num => [number_of_results]) returns a list of backlink texts to the given domain" do
    subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/links.linktexts?api_key=&domain=#{domain}&num=10").to_return(File.new(File.join(xml_base, 'links.linktexts.xml')))
    Sistrix.links_linktexts(:domain => domain, :num => 10)
  }

  it { should be }
  its(:credits) { should be 10 }
  its(:linktexts) { should be }
  it { should have(10).linktexts }

  describe "linktexts[0]" do
    let(:linktext) { subject.linktexts[0] }

    it "text should be ''" do
      linktext.text { should be '' }
    end

    it "links should be 2992" do
      linktext.links { should be 2992 }
    end

    it "hosts should be 836"  do
      linktext.hosts { should be 836 }
    end

    it "domains should be 576" do
      linktext.domains { should be 576 }
    end

    it "nets should be 327" do
      linktext.nets { should be 327 }
    end

    it "ips should be 406" do
      linktext.ips  { should be 406 }
    end
  end

  describe "linktexts[9]" do
    let(:linktext) { subject.linktexts[9] }

    it "text should be 'N/A'" do
      linktext.text { should be 'N/A' }
    end

    it "links should be 172" do
      linktext.links { should be 172 }
    end

    it "hosts should be 140"  do
      linktext.hosts { should be 140 }
    end

    it "domains should be 117" do
      linktext.domains { should be 117 }
    end

    it "nets should be 68" do
      linktext.nets { should be 68 }
    end

    it "ips should be 77" do
      linktext.ips  { should be 77 }
    end
  end

end
