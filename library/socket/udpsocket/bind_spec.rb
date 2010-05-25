require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "UDPSocket.bind" do
  
  before :each do
    @socket = UDPSocket.new
  end

  after :each do
    @socket.close unless @socket.closed?
  end

  it "binds the socket to a port" do
    @socket.bind(SocketSpecs.hostname, SocketSpecs.port)

    lambda { @socket.bind(SocketSpecs.hostname, SocketSpecs.port) }.should raise_error
  end

  it "receives a hostname and a port" do
    ax = @socket.bind(SocketSpecs.hostname, SocketSpecs.port)
    ax.should == 0
    #port, host = Socket.unpack_sockaddr_in(@socket.getsockname)  # not implemented yet
    
    #host.should == "127.0.0.1"
    #port.should == SocketSpecs.port
  end

  it "binds to INADDR_ANY if the hostname is empty" do
    ax = @socket.bind("", SocketSpecs.port)
    ax.should == 0
    # port, host = Socket.unpack_sockaddr_in(@socket.getsockname) # not implemented yet
    # host.should == "0.0.0.0"    
  end
end
