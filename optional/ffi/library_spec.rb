require File.expand_path('../spec_helper', __FILE__)

describe "FFI::Library" do
  it "attach_function with no library specified" do
    lambda {
      new_module { attach_function :getpid, [ ], :uint }
    }.should_not raise_error
  end

  it "attach_function :getpid from this process" do
    lambda {
      mod = new_module { attach_function :getpid, [ ], :uint }
      mod.getpid.should == Process.pid
    }.should_not raise_error
  end

  it "attach_function :getpid from [ 'c', 'libc.so.6'] " do
    lambda {
      not_compliant_on :maglev do
        mod = new_module('c', 'libc.so.6') { attach_function :getpid, [ ], :uint }
        mod.getpid.should == Process.pid
      end
      deviates_on :maglev do
        libnam = 'libc.so'
        if RUBY_PLATFORM.match('linux')
          libnam = '/lib/libc.so.6'
        end
        mod = new_module(libnam) { attach_function :getpid, [ ], :uint } 
        mod.getpid.should == Process.pid
      end
    }.should_not raise_error
  end

  it "attach_function :getpid from [ 'libc.so.6', 'c' ] " do
    libnam = 'libc.so'
    deviates_on :maglev do
      if RUBY_PLATFORM.match('linux')
        libnam = '/lib/libc.so.6'
      end
    end
    lambda {
      mod = new_module(libnam, 'c') { attach_function :getpid, [ ], :uint } 
      mod.getpid.should == Process.pid
    }.should_not raise_error
  end

  it "attach_function :getpid from [ 'libfubar.so.0xdeadbeef', nil, 'c' ] " do
    lambda {
      mod = new_module('libfubar.so.0xdeadbeef', nil, 'c') { attach_function :getpid, [ ], :uint }
      mod.getpid.should == Process.pid
    }.should_not raise_error
  end

  it "attach_function :getpid from [ 'libfubar.so.0xdeadbeef' ] " do
    lambda {
      mod = new_module('libfubar.so.0xdeadbeef') { attach_function :getpid, [ ], :uint }
      mod.getpid.should == Process.pid
    }.should raise_error(LoadError)
  end

 not_compliant_on :maglev do # global vars not implem yet
  it "Pointer variable" do
    lib = gvar_lib("pointer", :pointer)
    val = FFI::MemoryPointer.new :long
    lib.set(val)
    lib.gvar.should == val
    lib.set(nil)
    lib.gvar = val
    lib.get.should == val
  end

  [ 0, 127, -128, -1 ].each do |i|
    it ":char variable" do
      gvar_test("s8", :char, i)
    end
  end

  [ 0, 0x7f, 0x80, 0xff ].each do |i|
    it ":uchar variable" do
      gvar_test("u8", :uchar, i)
    end
  end

  [ 0, 0x7fff, -0x8000, -1 ].each do |i|
    it ":short variable" do
      gvar_test("s16", :short, i)
    end
  end

  [ 0, 0x7fff, 0x8000, 0xffff ].each do |i|
    it ":ushort variable" do
      gvar_test("u16", :ushort, i)
    end
  end

  [ 0, 0x7fffffff, -0x80000000, -1 ].each do |i|
    it ":int variable" do
      gvar_test("s32", :int, i)
    end
  end

  [ 0, 0x7fffffff, 0x80000000, 0xffffffff ].each do |i|
    it ":uint variable" do
      gvar_test("u32", :uint, i)
    end
  end

  [ 0, 0x7fffffffffffffff, -0x8000000000000000, -1 ].each do |i|
    it ":long_long variable" do
      gvar_test("s64", :long_long, i)
    end
  end

  [ 0, 0x7fffffffffffffff, 0x8000000000000000, 0xffffffffffffffff ].each do |i|
    it ":ulong_long variable" do
      gvar_test("u64", :ulong_long, i)
    end
  end

  if FFI::Platform::LONG_SIZE == 32
    [ 0, 0x7fffffff, -0x80000000, -1 ].each do |i|
      it ":long variable" do
        gvar_test("long", :long, i)
      end
    end

    [ 0, 0x7fffffff, 0x80000000, 0xffffffff ].each do |i|
      it ":ulong variable" do
        gvar_test("ulong", :ulong, i)
      end
    end
  else
    [ 0, 0x7fffffffffffffff, -0x8000000000000000, -1 ].each do |i|
      it ":long variable" do
        gvar_test("long", :long, i)
      end
    end

    [ 0, 0x7fffffffffffffff, 0x8000000000000000, 0xffffffffffffffff ].each do |i|
      it ":ulong variable" do
        gvar_test("ulong", :ulong, i)
      end
    end
  end
 end # maglev

  def self.new_module(*libs, &block)
    Module.new do
      extend FFI::Library
     not_compliant_on :maglev do
      ffi_lib(*libs) unless libs.empty?
     end
     deviates_on :maglev do
      ffi_lib(*libs)  # Maglev patch , need to clear previous global setting
     end
      module_eval(&block)
    end
  end

  def self.gvar_lib(name, type)
    new_module FFISpecs::LIBRARY do
      attach_variable :gvar, "gvar_#{name}", type
      attach_function :get, "gvar_#{name}_get", [], type
      attach_function :set, "gvar_#{name}_set", [ type ], :void
    end
  end

  def self.gvar_test(name, type, val)
    lib = gvar_lib(name, type)
    lib.set(val)
    lib.gvar.should == val
    lib.set(0)
    lib.gvar = val
    lib.get.should == val
  end
end
