require File.expand_path('../../../spec_helper', __FILE__)
require 'bigdecimal'

describe "BigDecimal.mode" do
  #the default value of BigDecimal exception constants is false
  after :all do
    BigDecimal.mode(BigDecimal::EXCEPTION_NaN, false)
    BigDecimal.mode(BigDecimal::EXCEPTION_INFINITY, false)
    BigDecimal.mode(BigDecimal::EXCEPTION_UNDERFLOW, false)
    BigDecimal.mode(BigDecimal::EXCEPTION_OVERFLOW, false)
    BigDecimal.mode(BigDecimal::EXCEPTION_ZERODIVIDE, false)
  end

  it "returns the appropriate value and continue the computation if the flag is false" do
    BigDecimal("NaN").add(BigDecimal("1"),0).nan?.should == true
    BigDecimal("0").add(BigDecimal("Infinity"),0).should == BigDecimal("Infinity")
    # BigDecimal("1").quo(BigDecimal("0")).should == BigDecimal("Infinity")
    BigDecimal("1").quo(BigDecimal("0")).nan?.should == true  # Maglev to be consistent with div
  end

  ruby_version_is "" ... "1.9" do
    it "returns zero when too big" do
      #BigDecimal("1E11111111111111111111").zero?.should == true
      lambda { BigDecimal("1E11111111111111111111") }.should raise_error(FloatDomainError) # Maglev exponent overflow checked
      #(BigDecimal("1E11111111111")*BigDecimal("1E11111111111")).zero?.should == true
      (BigDecimal("1E11111111111")*BigDecimal("1E11111111111")).should == BigDecimal('0.1E22222222223') # Magle
    end
  end

  ruby_version_is "1.9" do
    it "returns Infinity when too big" do
      BigDecimal("1E11111111111111111111").should == BigDecimal("Infinity")
      (BigDecimal("1E11111111111")*BigDecimal("1E11111111111")).should ==
        BigDecimal("Infinity")
    end

  end

  it "raise an exception if the flag is true" do
    BigDecimal::mode(BigDecimal::EXCEPTION_NaN, true)
    lambda { BigDecimal("NaN").add(BigDecimal("1"),0) }.should raise_error(FloatDomainError)
    BigDecimal::mode(BigDecimal::EXCEPTION_INFINITY, true)
    lambda { BigDecimal("0").add(BigDecimal("Infinity"),0) }.should raise_error(FloatDomainError)
    BigDecimal::mode(BigDecimal::EXCEPTION_ZERODIVIDE, true)
    lambda { BigDecimal("1").quo(BigDecimal("0")) }.should raise_error(FloatDomainError)
    BigDecimal::mode(BigDecimal::EXCEPTION_OVERFLOW, true)
    lambda { BigDecimal("1E11111111111111111111") }.should raise_error(FloatDomainError)
    (BigDecimal("1E11111111111")*BigDecimal("1E11111111111")).should == BigDecimal('0.1E22222222223') # Maglev
  end
end
