# encoding: utf-8

require 'spec_helper'
require 'sistrix'

WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')


describe "Sistrix.credits() returns the current number of credits for the current API_KEY" do

  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/credits?api_key=").to_return(File.new(File.join(xml_base, 'credits.xml')))
    Sistrix.credits()
  }

  it { should be }

  its(:credits) { should == 0 }
  its(:credits_available) { should == 40000 }

end
