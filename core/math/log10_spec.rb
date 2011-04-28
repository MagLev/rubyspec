require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

# The common logarithm, having base 10
describe "Math.log10" do
  it "returns a float" do
    Math.log10(1).should be_kind_of(Float)
  end

  it "return the base-10 logarithm of the argument" do
    Math.log10(0.0001).should be_close(-4.0, TOLERANCE)
    Math.log10(0.000000000001e-15).should be_close(-27.0, TOLERANCE)
    Math.log10(1).should be_close(0.0, TOLERANCE)
    Math.log10(10).should be_close(1.0, TOLERANCE)
    Math.log10(10e15).should be_close(16.0, TOLERANCE)
  end
  
   conflicts_with :Complex do
     do_test = true
     deviates_on :maglev do
      if RUBY_PLATFORM.match('solaris') 
        do_test = false # x86 solaris libs fails to raise EDOM
      end
     end
     if do_test
       it "raises an Errno::EDOM if the argument is less than 0" do
         lambda { Math.log10(-1e-15) }.should raise_error( Errno::EDOM)
       end
     end
   end
  
  ruby_version_is ""..."1.9" do
    it "raises an ArgumentError if the argument cannot be coerced with Float()" do
      not_compliant_on :maglev do
        lambda { Math.log10("test") }.should raise_error(ArgumentError)
      end
      deviates_on :maglev do
        lambda { Math.log10("test") }.should raise_error(TypeError)
      end
    end
  end

  ruby_version_is "1.9" do
    it "raises a TypeError if the argument cannot be coerced with Float()" do
      lambda { Math.log10("test") }.should raise_error(TypeError)
    end
  end

  it "raises a TypeError if the argument is nil" do
    lambda { Math.log10(nil) }.should raise_error(TypeError)
  end

  it "accepts any argument that can be coerced with Float()" do
    Math.log10(MathSpecs::Float.new).should be_close(0.0, TOLERANCE)
  end
end

describe "Math#log10" do
  it "is accessible as a private instance method" do
    IncludesMath.new.send(:log10, 4.15).should be_close(0.618048096712093, TOLERANCE)
  end
end
