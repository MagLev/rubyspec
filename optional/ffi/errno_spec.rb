require File.expand_path('../spec_helper', __FILE__)

describe "FFI.errno" do
  it "FFI.errno contains errno from last function" do
    FFISpecs::LibTest.setLastError(33)  
    FFI.errno  # clear it	
    FFI.errno.should == 0
    FFISpecs::LibTest.setLastError(0x12345678)
    FFI.errno.should == 0x12345678
  end
end
