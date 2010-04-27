require File.expand_path('../../spec_helper', __FILE__)

describe FFI::Struct do
  it "allows setting fields" do
    klass = Class.new(FFI::Struct)
 #  klass.layout :tv_sec, :ulong, 0, :tv_usec, :ulong, 4
    klass.layout :tv_sec, :ulong, 0, :tv_usec, :ulong, 8 # maglev, longs are 8 bytes

    t = klass.new
    t[:tv_sec] = 12
    t[:tv_sec].should == 12
  end
end
