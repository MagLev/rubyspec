require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../shared/quo', __FILE__)
require 'bigdecimal'

describe "BigDecimal#div with precision set to 0" do
  # TODO: figure out if there is a better way to do these
  # shared specs rather than sending [0]. See other specs
  # that share :bigdecimal_quo.
  it_behaves_like :bigdecimal_quo, :div, [0]
end

describe "BigDecimal#div" do

  before(:each) do
    @one = BigDecimal("1")
    @zero = BigDecimal("0")
    @zero_plus = BigDecimal("+0")
    @zero_minus = BigDecimal("-0")
    @two = BigDecimal("2")
    @three = BigDecimal("3")
    @nan = BigDecimal("NaN")
    @infinity = BigDecimal("Infinity")
    @infinity_minus = BigDecimal("-Infinity")
    @one_minus = BigDecimal("-1")
    @frac_1 = BigDecimal("1E-99999")
    @frac_2 = BigDecimal("0.9E-99999")
  end

  it "returns a / b with optional precision" do
    @two.div(@one).should == @two
    #@one.div(@two))).should == @zero
    # ^^ is this really intended for a class with arbitrary precision?
    @one.div(@two).should == BigDecimal("0.5") # Maglev, div() defaults to unlimited precision

    @one.div(@two, 1).should == BigDecimal("0.5")
    @one.div(@one_minus).should == @one_minus
    @one_minus.div(@one_minus).should == @one
    @frac_2.div(@frac_1, 1).should == BigDecimal("0.9")
    @frac_1.div(@frac_1).should == @one

    res = "0." + "3" * 1000
    (1..100).each { |idx|
      (nc = (na = @one).div((nb = @three), idx)).to_s("F").should == (str = "0." + res[2, idx])
    }
  end

  ruby_version_is "" ... "1.9" do
    it "returns NaN if NaN is involved" do
      @one.div(@nan).nan?.should == true
      @nan.div(@one).nan?.should == true
    end

    it "returns NaN if divided by Infinity and no precision given" do
      @zero.div(@infinity).nan?.should == true
      @frac_2.div(@infinity).nan?.should == true
    end
  end

  ruby_version_is "1.9" do
    it "raises FloatDomainError if NaN is involved" do
      lambda { @one.div(@nan) }.should raise_error(FloatDomainError)
      lambda { @nan.div(@one) }.should raise_error(FloatDomainError)
    end

    it "returns 0 if divided by Infinity and no precision given" do
      @zero.div(@infinity).should == 0
      @frac_2.div(@infinity).should == 0
    end
  end

  it "returns 0 if divided by Infinity with given precision" do
    @zero.div(@infinity, 1).should == 0 # Maglev, 0 implies unlimited precision
    @frac_2.div(@infinity, 1).should == 0
    @zero.div(@infinity, 100000).should == 0
    @frac_2.div(@infinity, 100000).should == 0
  end
  
  ruby_version_is "" ... "1.9" do
    it "returns NaN if divided by zero and no precision given" do
      @one.div(@zero).nan?.should == true
      @one.div(@zero_plus).nan?.should == true
      @one.div(@zero_minus).nan?.should == true
    end

    it "returns NaN if zero is divided by zero" do
      @zero.div(@zero).nan?.should == true
      @zero_minus.div(@zero_plus).nan?.should == true
      @zero_plus.div(@zero_minus).nan?.should == true

      @zero.div(@zero, 0).nan?.should == true
      @zero_minus.div(@zero_plus, 0).nan?.should == true
      @zero_plus.div(@zero_minus, 0).nan?.should == true

      @zero.div(@zero, 10).nan?.should == true
      @zero_minus.div(@zero_plus, 10).nan?.should == true
      @zero_plus.div(@zero_minus, 10).nan?.should == true
    end

    it "returns NaN if (+|-) Infinity divided by 1 and no precision given" do
      @infinity_minus.div(@one).nan?.should == true
      @infinity.div(@one).nan?.should == true
      @infinity_minus.div(@one_minus).nan?.should == true
    end
  end
  
  ruby_version_is "1.9" do
    it "raises ZeroDivisionError if divided by zero and no precision given" do
      lambda { @one.div(@zero) }.should raise_error(ZeroDivisionError)
      lambda { @one.div(@zero_plus) }.should raise_error(ZeroDivisionError)
      lambda { @one.div(@zero_minus) }.should raise_error(ZeroDivisionError)

      lambda { @zero.div(@zero) }.should raise_error(ZeroDivisionError)
      lambda { @zero_minus.div(@zero_plus) }.should raise_error(ZeroDivisionError)
      lambda { @zero_plus.div(@zero_minus) }.should raise_error(ZeroDivisionError)
    end

    it "returns NaN if zero is divided by zero" do
      @zero.div(@zero, 0).nan?.should == true
      @zero_minus.div(@zero_plus, 0).nan?.should == true
      @zero_plus.div(@zero_minus, 0).nan?.should == true

      @zero.div(@zero, 10).nan?.should == true
      @zero_minus.div(@zero_plus, 10).nan?.should == true
      @zero_plus.div(@zero_minus, 10).nan?.should == true
    end

    it "raises FloatDomainError if (+|-) Infinity divided by 1 and no precision given" do
      lambda { @infinity_minus.div(@one) }.should raise_error(FloatDomainError)
      lambda { @infinity.div(@one) }.should raise_error(FloatDomainError)
      lambda { @infinity_minus.div(@one_minus) }.should raise_error(FloatDomainError)
    end
  end

  it "returns (+|-)Infinity if (+|-)Infinity by 1 and precision given" do
    @infinity_minus.div(@one, 5).should == @infinity_minus #  Maglev, precision given means prec>0
    @infinity.div(@one, 5).should == @infinity
    @infinity_minus.div(@one_minus, 5).should == @infinity
  end

  it "returns NaN if Infinity / ((+|-) Infinity)" do
    @infinity.div(@infinity_minus, 100000).nan?.should == true
    @infinity_minus.div(@infinity, 1).nan?.should == true
  end


end
