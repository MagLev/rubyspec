require File.expand_path('../spec_helper', __FILE__)

describe "Custom type definitions" do
  before :each do
    @mod = Module.new do
      extend FFI::Library
      ffi_lib FFISpecs::LIBRARY
    end
  end

  it "attach_function with custom typedef" do
    @mod.typedef :uint, :fubar_t
    @mod.attach_function :ret_u32, [ :fubar_t ], :fubar_t

    @mod.ret_u32(0x12345678).should == 0x12345678
  end

  it "variadic invoker with custom typedef" do
    @mod.typedef :uint, :fubar_t
    @mod.attach_function :pack_varargs, [ :buffer_out, :string, :varargs ], :void

#   buf = FFI::Buffer.new :uint, 10
#   @mod.pack_varargs(buf, "i", :fubar_t, 0x12345678)
#   buf.get_int64(0).should == 0x12345678
    buf = FFI::Buffer.new( :int64, 10 )		# maglev patches to spec
    @mod.pack_varargs(buf, "ij", :int, 88, :int64, 0x12345678)  
    buf.get_int64(0).should == 88
    buf.get_int64(8).should == 0x12345678
  end

  it "Callback with custom typedef parameter" do  
    @mod.typedef :uint, :fubar3_t
    @mod.callback :cbIrVxx, [ :fubar3_t ], :void # maglev duplicate callback names not allowed
    @mod.attach_function :testCallbackU32rV, :testClosureIrV, [ :cbIrVxx, :fubar3_t ], :void  
    @mod.attach_function :testU32_Callback_V, :testIClosure_rV, [ :fubar3_t, :cbIrVxx], :void   # maglev addition

    i = 0
    # @mod.testCallbackU32rV(0xdeadbeef) { |v| i = v }
    pclx = Proc
    px = Proc.new { |v| i = v }
    @mod.testCallbackU32rV(px, 0xdeadbeef)   # maglev, no support for auto-reordering of args
    i.should == 0xdeadbeef
    @mod.testU32_Callback_V(0x1234abcd) { |y| i = y } # maglev addition
    i.should == 0x1234abcd
  end

  it "Struct with custom typedef field" do
    s = FFISpecs::StructCustomTypedef::S.new
    s[:a] = 0x12345678
    s.pointer.get_uint(0).should == 0x12345678
  end
end
