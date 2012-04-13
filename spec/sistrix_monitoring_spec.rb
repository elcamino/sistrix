# encoding: utf-8

require 'spec_helper'
require 'sistrix'
require 'digest/md5'
require 'pp'



WebMock.disable_net_connect!
include WebMock::API

xml_base =  File.join(File.dirname(__FILE__), 'xml')
domain   = 'zeit.de'
keyword  = 'auto'




describe "Sistrix.monitoring_projects() returns the complete list of projects for your API key" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/monitoring.projects?api_key=").to_return(File.new(File.join(xml_base, 'monitoring.projects.xml')))
    Sistrix.monitoring_projects()
  }

  it { should be }

  its(:credits) { should be 0 }

  its(:projects) { should be }
  it { should have(19).projects }

  describe "projects[0]" do
    let(:project) { subject.projects[0] }

    it "name should be 'aaaaaaaaaaa.aa'" do
      project.name { should be 'aaaaaaaaaaa.aa' }
    end

    it "id should be 'aaaaaaaa'" do
      project.id { should be 'aaaaaaaa' }
    end
  end

  describe "projects.last" do
    let(:project) { subject.projects.last }

    it "name should be 'sssssssssssss'" do
      project.name { should be 'sssssssssssss' }
    end

    it "id should be 'ssssssss'" do
      project.id { should be 'ssssssss' }
    end
  end

end

describe "Sistrix.monitoring_folders(:project => [project]) returns the list of folders for one project" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/monitoring.folders?api_key=&project=56366").to_return(File.new(File.join(xml_base, 'monitoring.folders.xml')))
    Sistrix.monitoring_folders(:project => '56366')
  }

  it { should be }

  its(:credits) { should be 0 }

  its(:folders) { should be }
  it { should have(2).folders }

  describe "folders[0]" do
    let(:folder) { subject.folders[0] }

    it "name should be 'aaaaa a aaaa'" do
      folder.name { should be 'aaaaa a aaaa' }
    end

    it "id should be 1111" do
      folder.id { should be 5360 }
    end

    it "parent should be 0" do
      folder.parent { should be 0 }
    end

  end
end

describe "Sistrix.monitoring_reports(:project => [project]) returns the list of available reports for one project" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/monitoring.reports?api_key=&project=56366").to_return(File.new(File.join(xml_base, 'monitoring.reports.xml')))
    Sistrix.monitoring_reports(:project => '56366')
  }

  it { should be }

  its(:credits) { should be 0 }

  its(:reports) { should be }
  it { should have(1).reports }

  describe "reports[0]" do
    let(:report) { subject.reports[0] }

    it "name should be 'Oktober'" do
      report.name { should be 'Oktober' }
    end

    it "id should be aaaaaaaaaaaaaaaa" do
      report.id { should be 'aaaaaaaaaaaaaaaa' }
    end
  end
end


describe "Sistrix.monitoring_report(:project => [project], :report => [report]) returns the list of available report instances for the given project and report" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/monitoring.report?api_key=&project=56366&report=12356").to_return(File.new(File.join(xml_base, 'monitoring.report.xml')))
    Sistrix.monitoring_report(:project => '56366', :report => 12356)
  }

  it { should be }

  its(:credits) { should be 0 }

  its(:frequency) { should == 'weekly' }
  its(:name) { should == 'Oktober'}
  its(:id) { should == 'aaaaaaaaaaaaaaaa' }
  its(:format) { should == 'pdf' }

  its(:recipients) { should be }
  it { should have(1).recipients }

  describe "recipients[0]" do
    let(:recipient) { subject.recipients[0] }

    it "value should be 'aa'" do
      recipient.value { should be 'aa' }
    end

    it "type should be 'user'" do
      recipient.type { should be 'user' }
    end
  end

  it { should have(154).reports }
  describe "reports[0]" do
    let(:report) { subject.reports[0] }

    it "date should be '2009-11-04T00:00:00+01:00'" do
      report.date { should be Time.parse('2009-11-04T00:00:00+01:00') }
    end

    it "format should be 'pdf'" do
      report.format { should be 'pdf' }
    end
  end


end


describe "Sistrix.monitoring_report_download(:project => [project], :report => [report], :date => [date]) downloads a PDF or XLS version of the specified report" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/monitoring.report.download?api_key=&project=56366&report=12356&date=2009-11-04").to_return(File.new(File.join(xml_base, 'monitoring.report.download.pdf')))
    Sistrix.monitoring_report_download(:project => '56366', :report => '12356', :date => '2009-11-04')
  }

  it { should be }

  its("data.length") { should be 85487 }

  its(:data) { should satisfy { |data| Digest::MD5.hexdigest(data) == 'cf916dbe79c66e19b4e662ce376e8ae1' } }
end


describe "Sistrix.monitoring_report_download(:project => [project], :report => [report], :date => [erroneous_date]) returns an error when downloading a PDF or XLS version of the specified report" do
  subject {
    stub_request(:get, Sistrix::SERVICE_HOST + "/monitoring.report.download?api_key=&project=56366&report=12356&date=2009-11-04653").to_return(File.new(File.join(xml_base, 'monitoring.report.download_error.xml')))
    Sistrix.monitoring_report_download(:project => '56366', :report => '12356', :date => '2009-11-04653')
  }

  it { should be }

  its("error?") { should be_true }
  its("error.code") { should == '005' }
  its("error.message") { should == 'Date not found' }

end
