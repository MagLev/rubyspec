require File.expand_path('../spec_helper', __FILE__)

describe FFI::Struct, ' with inline callback functions' do
  # Maglev,  callbacks not supported as values of struct fields.
  it 'should be able to define inline callback field' do
    lambda {
      Module.new do
        extend FFI::Library
        ffi_lib FFISpecs::LIBRARY

        struct = Class.new(FFI::Struct) do
          layout( :add, callback([ :int, :int ], :int),		# maglev code formatting
                  :sub, callback([ :int, :int ], :int) )
        end

        attach_function( :struct_call_add_cb, [struct, :int, :int], :int ) # maglev code formatting
        attach_function( :struct_call_sub_cb, [struct, :int, :int], :int )
      end
    }.should_not raise_error
  end
end
