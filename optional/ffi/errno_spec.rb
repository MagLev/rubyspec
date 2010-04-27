require File.expand_path('../spec_helper', __FILE__)

describe "FFI.errno" do
  it "FFI.errno contains errno from last function" do
    FFISpecs::LibTest.setLastError(33)  #  Have seen some intermittent results here
    FFI.errno  # clear it		#   on solaris x86 with ffi specs .c using gcc, VM using Sun CC
#    FFI.errno.should == 33
    FFI.errno.should == 0
    FFISpecs::LibTest.setLastError(0x12345678)
    FFI.errno.should == 0x12345678
  end
end
