# encoding: utf-8

require 'spec_helper'
require 'sistrix'
require 'pp'

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

  its(:credits) { should == 25 }
  its(:total) { should == 2357268 }
  its(:hosts) { should == 84489 }
  its(:domains) { should == 51929 }
  its(:networks) { should == 28613 }
  its(:class_c) { should == 11878 }
end

