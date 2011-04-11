require File.expand_path('../../spec_helper', __FILE__)

describe FFI::Struct do
  it "allows setting fields" do
    klass = Class.new(FFI::Struct)
    long_size_bytes = FFI::Platform::LONG_SIZE / 8
    klass.layout(:tv_sec, :ulong, 0, :tv_usec, :ulong, long_size_bytes)

    t = klass.new
    t[:tv_sec] = 12
    t[:tv_sec].should == 12
  end
end
