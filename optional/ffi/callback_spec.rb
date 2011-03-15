require File.expand_path('../spec_helper', __FILE__)

describe "Callback" do

  module LibC
    extend FFI::Library  # maglev patch spec, missing FFI::
    callback :qsort_cmp, [ :pointer, :pointer ], :int
    if RUBY_PLATFORM.match('solaris')
      ffi_lib('libc.so') # maglev needs
    end
    if RUBY_PLATFORM.match('linux')
      ffi_lib('/lib/libc.so.6') # maglev needs
    end
    attach_function :qsort, [ :pointer, :int, :int, :qsort_cmp ], :int
  end
  it "arguments get passed correctly" do
    p = FFI::MemoryPointer.new(:int, 2)
    # p.put_array_of_int32(0, [ 1 , 2 ]) # maglev put_array_of_int32 not implem
    p.write_array_of_int([ 1 , 2 ])  # 
    args = []
    cmp = proc do |p1, p2| args.push(p1.get_int(0)); args.push(p2.get_int(0)); 0; end
    # this is a bit dodgey, as it relies on qsort passing the args in order
    LibC.qsort(p, 2, 4, cmp)
    args.should == [ 1, 2 ]
  end

  it "Block can be substituted for Callback as last argument" do
    p = FFI::MemoryPointer.new(:int, 2)
    # p.put_array_of_int32(0, [ 1 , 2 ]) # maglev put_array_of_int32 not implem
    p.write_array_of_int([ 1 , 2 ])  #
    args = []
    # this is a bit dodgey, as it relies on qsort passing the args in order
    LibC.qsort(p, 2, 4) do |p1, p2|
      args.push(p1.get_int(0))
      args.push(p2.get_int(0))
      0
    end
    args.should == [ 1, 2 ]
  end

  it "function with Callback plus another arg should raise error if no arg given" do
    lambda { FFISpecs::LibTest.testCallbackCrV { |*a| } }.should raise_error
  end

  # following are callbacks with zero args, testing various return types # [
  it "returning :char (0)" do
    FFISpecs::LibTest.testCallbackVrS8 { 0 }.should == 0
  end

  it "returning :char (127)" do
    FFISpecs::LibTest.testCallbackVrS8 { 127 }.should == 127
  end

  it "returning :char (-128)" do
    FFISpecs::LibTest.testCallbackVrS8 { -128 }.should == -128
  end

  # test wrap around
  it "returning :char (128)" do
    FFISpecs::LibTest.testCallbackVrS8 { 128 }.should == -128
  end

  it "returning :char (255)" do
    FFISpecs::LibTest.testCallbackVrS8 { 0xff }.should == -1
  end

  it "returning :uchar (0)" do
    FFISpecs::LibTest.testCallbackVrU8 { 0 }.should == 0
  end

  it "returning :uchar (0xff)" do
    FFISpecs::LibTest.testCallbackVrU8 { 0xff }.should == 0xff
  end

  it "returning :uchar (-1)" do
    FFISpecs::LibTest.testCallbackVrU8 { -1 }.should == 0xff
  end

  it "returning :uchar (128)" do
    FFISpecs::LibTest.testCallbackVrU8 { 128 }.should == 128
  end

  it "returning :uchar (-128)" do
    FFISpecs::LibTest.testCallbackVrU8 { -128 }.should == 128
  end

  it "returning :short (0)" do
    FFISpecs::LibTest.testCallbackVrS16 { 0 }.should == 0
  end

  it "returning :short (0x7fff)" do
    FFISpecs::LibTest.testCallbackVrS16 { 0x7fff }.should == 0x7fff
  end
  # ]

  # test wrap around # [
  it "returning :short (0x8000)" do
    FFISpecs::LibTest.testCallbackVrS16 { 0x8000 }.should == -0x8000
  end

  it "returning :short (0xffff)" do
    FFISpecs::LibTest.testCallbackVrS16 { 0xffff }.should == -1
  end

  it "returning :ushort (0)" do
    FFISpecs::LibTest.testCallbackVrU16 { 0 }.should == 0
  end

  it "returning :ushort (0x7fff)" do
    FFISpecs::LibTest.testCallbackVrU16 { 0x7fff }.should == 0x7fff
  end

  it "returning :ushort (0x8000)" do
    FFISpecs::LibTest.testCallbackVrU16 { 0x8000 }.should == 0x8000
  end

  it "returning :ushort (0xffff)" do
    FFISpecs::LibTest.testCallbackVrU16 { 0xffff }.should == 0xffff
  end

  it "returning :ushort (-1)" do
    FFISpecs::LibTest.testCallbackVrU16 { -1 }.should == 0xffff
  end

  it "returning :int (0)" do
    FFISpecs::LibTest.testCallbackVrS32 { 0 }.should == 0
  end

  it "returning :int (0x7fffffff)" do
    FFISpecs::LibTest.testCallbackVrS32 { 0x7fffffff }.should == 0x7fffffff
  end

  # test wrap around
  it "returning :int (-0x80000000)" do
    FFISpecs::LibTest.testCallbackVrS32 { -0x80000000 }.should == -0x80000000
  end

  it "returning :int (-1)" do
    FFISpecs::LibTest.testCallbackVrS32 { -1 }.should == -1
  end

  it "returning :uint (0)" do
    FFISpecs::LibTest.testCallbackVrU32 { 0 }.should == 0
  end

  it "returning :uint (0x7fffffff)" do
    FFISpecs::LibTest.testCallbackVrU32 { 0x7fffffff }.should == 0x7fffffff
  end

  # test wrap around
  it "returning :uint (0x80000000)" do
    FFISpecs::LibTest.testCallbackVrU32 { 0x80000000 }.should == 0x80000000
  end

  it "returning :uint (0xffffffff)" do
    FFISpecs::LibTest.testCallbackVrU32 { 0xffffffff }.should == 0xffffffff
  end

  it "Callback returning :uint (-1)" do
    FFISpecs::LibTest.testCallbackVrU32 { -1 }.should == 0xffffffff
  end

  it "returning :long (0)" do
    FFISpecs::LibTest.testCallbackVrL { 0 }.should == 0
  end

  it "returning :long (0x7fffffff)" do
    FFISpecs::LibTest.testCallbackVrL { 0x7fffffff }.should == 0x7fffffff
  end

  # test wrap around
  it "returning :long (-0x80000000)" do
    FFISpecs::LibTest.testCallbackVrL { -0x80000000 }.should == -0x80000000
  end

  it "returning :long (-1)" do
    FFISpecs::LibTest.testCallbackVrL { -1 }.should == -1
  end

  it "returning :ulong (0)" do
    FFISpecs::LibTest.testCallbackVrUL { 0 }.should == 0
  end

  it "returning :ulong (0x7fffffff)" do
    FFISpecs::LibTest.testCallbackVrUL { 0x7fffffff }.should == 0x7fffffff
  end

  # test wrap around
  it "returning :ulong (0x80000000)" do
    FFISpecs::LibTest.testCallbackVrUL { 0x80000000 }.should == 0x80000000
  end

  it "returning :ulong (0xffffffff)" do
    FFISpecs::LibTest.testCallbackVrUL { 0xffffffff }.should == 0xffffffff
  end

  it "Callback returning :ulong (-1)" do
    # FFISpecs::LibTest.testCallbackVrUL { -1 }.should == 0xffffffff 
    # maglev , negative results not allowed when result type is unsigned 
    lambda { FFISpecs::LibTest.testCallbackVrUL { -1 }  }.should raise_error(ArgumentError) #
  end

  it "returning :long_long (0)" do
    FFISpecs::LibTest.testCallbackVrS64 { 0 }.should == 0
  end

  it "returning :long_long (0x7fffffffffffffff)" do
    FFISpecs::LibTest.testCallbackVrS64 { 0x7fffffffffffffff }.should == 0x7fffffffffffffff
  end

  # test wrap around
  it "returning :long_long (-0x8000000000000000)" do
    FFISpecs::LibTest.testCallbackVrS64 { -0x8000000000000000 }.should == -0x8000000000000000
  end

  it "returning :long_long (-1)" do
    FFISpecs::LibTest.testCallbackVrS64 { -1 }.should == -1
  end
  # end of test wrap around # ]

  it "returning :pointer (nil)" do
    FFISpecs::LibTest.testCallbackVrP { nil }.null?.should be_true
  end

  it "returning :pointer (FFI::MemoryPointer)" do
    p = FFI::MemoryPointer.new :long
    (ax = FFISpecs::LibTest.testCallbackVrP { p }).should == p
  end

 not_compliant_on :maglev do #  global variables not implem yet
  it "global variable" do #
    proc = Proc.new { 0x1e }
    FFISpecs::LibTest.cbVrS8 = proc
    FFISpecs::LibTest.testGVarCallbackVrS8(FFISpecs::LibTest.pVrS8).should == 0x1e
  end
 end #

  describe "When the callback is considered optional by the underlying library" do
    it "should handle receiving 'nil' in place of the closure" do
      lambda { FFISpecs::LibTest.testOptionalCallbackCrV(nil, 13) }.should_not raise_error
    end
  end

  describe 'when inlined' do
    it 'could be anonymous' do
      FFISpecs::LibTest.testCallbackVrS8 { 0 }.should == 0
    end
  end

 unless defined?(Maglev::System) # nested callback not supported yet by maglev # [
  describe "as return value" do
    it "should not blow up when a callback is defined that returns a callback" do
      lambda {
        FFISpecs::LibTest.module_eval do
          callback( :cb_return_type_1, [ :short ], :short )
          callback( :cb_lookup_1, [ :short ], :cb_return_type_1 )
          attach_function( :testReturnsCallback_1, :testReturnsClosure, [ :cb_lookup_1, :short ], :cb_return_type_1 )
        end
      }.should_not raise_error
    end

    it "should return a callback" do
      lookup_proc_called = false
      return_proc_called = false

      return_proc = Proc.new do |a|
        return_proc_called = true
        a * 2
      end
      lookup_proc = Proc.new do
        lookup_proc_called = true
        return_proc
      end

      val = FFISpecs::LibTest.testReturnsCallback(lookup_proc, 0x1234)
      val.should == 0x1234 * 2
      lookup_proc_called.should be_true
      return_proc_called.should be_true
    end

    it 'should not blow up when a callback takes a callback as argument' do
      lambda {
        FFISpecs::LibTest.module_eval do
          callback :cb_argument, [ :int ], :int
          callback :cb_with_cb_argument, [ :cb_argument, :int ], :int
          attach_function :testCallbackAsArgument, :testArgumentClosure, [ :cb_with_cb_argument, :int ], :int
        end
      }.should_not raise_error
    end

    it 'should be able to use the callback argument' do
      # TODO: Moving this to fixtures/classes.rb breaks
      module FFISpecs::LibTest
        callback :cb_argument, [ :int ], :int
        callback :cb_with_cb_argument, [ :cb_argument, :int ], :int
        attach_function :testCallbackAsArgument, :testArgumentClosure, [ :cb_with_cb_argument, :cb_argument, :int ], :int
      end

      callback_arg_called = false
      callback_with_callback_arg_called = false

      callback_arg = Proc.new do |val|
        callback_arg_called = true
        val * 2
      end
      callback_with_callback_arg = Proc.new do |cb, val|
        callback_with_callback_arg_called = true
        cb.call(val)
      end

      val = FFISpecs::LibTest.testCallbackAsArgument(callback_with_callback_arg, callback_arg, 0xff1)

      val.should == 0xff1 * 2
      callback_arg_called.should be_true
      callback_with_callback_arg_called.should be_true
    end

    it 'function returns callable object' do
      f = FFISpecs::LibTest.testReturnsFunctionPointer
      f.call(3).should == 6
    end
  end
 end # maglev ]
end

describe "primitive argument" do
  it ":char (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackCrV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":char (127) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackCrV(px, 127) # { |i| v = i }
    v.should == 127
  end

  it ":char (-128) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackCrV(px, -128) # { |i| v = i }
    v.should == -128
  end

  it ":char (-1) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackCrV(px, -1)  #
    v.should == -1
  end

  it ":uchar (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU8rV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":uchar (127) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU8rV(px, 127) # { |i| v = i }
    v.should == 127
  end

  it ":uchar (128) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU8rV(px, 128) # { |i| v = i }
    v.should == 128
  end

  it ":uchar (255) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU8rV(px, 255) # { |i| v = i }
    v.should == 255
  end

  it ":short (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackSrV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":short (0x7fff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackSrV(px, 0x7fff) # { |i| v = i }
    v.should == 0x7fff
  end

  it ":short (-0x8000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackSrV(px, -0x8000) # { |i| v = i }
    v.should == -0x8000
  end

  it ":short (-1) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackSrV(px, -1) # { |i| v = i }
    v.should == -1
  end

  it ":ushort (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU16rV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":ushort (0x7fff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU16rV(px, 0x7fff) # { |i| v = i }
    v.should == 0x7fff
  end

  it ":ushort (0x8000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU16rV(px, 0x8000) # { |i| v = i }
    v.should == 0x8000
  end

  it ":ushort (0xffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU16rV(px, 0xffff) # { |i| v = i }
    v.should == 0xffff
  end

  it ":int (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackIrV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":int (0x7fffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackIrV(px, 0x7fffffff) # { |i| v = i }
    v.should == 0x7fffffff
  end

  it ":int (-0x80000000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackIrV(px, -0x80000000) # { |i| v = i }
    v.should == -0x80000000
  end

  it ":int (-1) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackIrV(px, -1) # { |i| v = i }
    v.should == -1
  end

  it ":uint (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU32rV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":uint (0x7fffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU32rV(px, 0x7fffffff) # { |i| v = i }
    v.should == 0x7fffffff
  end

  it ":uint (0x80000000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU32rV(px, 0x80000000) # { |i| v = i }
    v.should == 0x80000000
  end

  it ":uint (0xffffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackU32rV(px, 0xffffffff) # { |i| v = i }
    v.should == 0xffffffff
  end

  it ":long (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLrV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":long (0x7fffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLrV(px, 0x7fffffff) # { |i| v = i }
    v.should == 0x7fffffff
  end

  it ":long (-0x80000000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLrV(px, -0x80000000) # { |i| v = i }
    v.should == -0x80000000
  end

  it ":long (-1) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLrV(px, -1) # { |i| v = i }
    v.should == -1
  end

  it ":ulong (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackULrV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":ulong (0x7fffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackULrV(px, 0x7fffffff) # { |i| v = i }
    v.should == 0x7fffffff
  end

  it ":ulong (0x80000000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackULrV(px, 0x80000000) # { |i| v = i }
    v.should == 0x80000000
  end

  it ":ulong (0xffffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackULrV(px, 0xffffffff) # { |i| v = i }
    v.should == 0xffffffff
  end

  it ":long_long (0) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLLrV(px, 0) # { |i| v = i }
    v.should == 0
  end

  it ":long_long (0x7fffffffffffffff) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLLrV(px, 0x7fffffffffffffff) # { |i| v = i }
    v.should == 0x7fffffffffffffff
  end

  it ":long_long (-0x8000000000000000) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLLrV(px, -0x8000000000000000) # { |i| v = i }
    v.should == -0x8000000000000000
  end

  it ":long_long (-1) argument" do
    v = 0xdeadbeef
    px = Proc.new { |i| v = i } # maglev no auto-reordering of args
    FFISpecs::LibTest.testCallbackLLrV(px, -1) # { |i| v = i }
    v.should == -1
  end
end
