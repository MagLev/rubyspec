require File.expand_path('../../spec_helper', __FILE__)

describe FFI::Library, "#attach_function" do
  before :all do
    @klass = Class.new(FFI::Struct)
    long_size_bytes = FFI::Platform::LONG_SIZE / 8
    @klass.layout(:tv_sec, :ulong, 0, :tv_usec, :ulong, long_size_bytes)

    @libc = Module.new do
      extend FFI::Library
      deviates_on :maglev do
        libnam = 'libc.so'
        if RUBY_PLATFORM.match('linux')
          libnam = '/lib/libc.so.6' # maglev
        end
        ffi_lib( libnam )
      end
      attach_function :gettimeofday, [:pointer, :pointer], :int
    end
  end

  before :each do
    @t = @klass.new
    @time = @libc.gettimeofday(@t.pointer, nil)
  end

  it "correctly returns a value for gettimeofday" do
    @time.should be_kind_of(Integer)
  end

  it "correctly populates a struct for gettimeofday" do
    @t[:tv_sec].should be_kind_of(Numeric)
    @t[:tv_usec].should be_kind_of(Numeric)
  end
end
