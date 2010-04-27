require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "Socket::IPSocket#getaddress" do

  it "returns the IP address of hostname" do
    addr_local = IPSocket.getaddress(SocketSpecs.hostname)
    ["127.0.0.1", "::1"].include?(addr_local).should == true
  end

  it "returns the IP address when passed an IP" do
    IPSocket.getaddress("127.0.0.1").should == "127.0.0.1"
    IPSocket.getaddress("0.0.0.0").should == "0.0.0.0"
  end

  it "raises an error on unknown hostnames" do
    lambda { IPSocket.getaddress("imfakeidontexistanditrynottobeslow.com") }.should raise_error(SocketError)
  end

end
