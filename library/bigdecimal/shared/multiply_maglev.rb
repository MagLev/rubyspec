# file multiply_maglev.rb 
require 'bigdecimal'

describe :bigdecimal_mult, :shared => true do
  before :each do
    @zero = BigDecimal "0"
    @zero_pos = BigDecimal "+0"
    @zero_neg = BigDecimal "-0"

    @one = BigDecimal "1"
    @mixed = BigDecimal "1.23456789"
    @pos_int = BigDecimal "2E5555"
    @neg_int = BigDecimal "-2E5555"
    @pos_frac = BigDecimal "2E-9999"
    @neg_frac = BigDecimal "-2E-9999"
    @nan = BigDecimal "NaN"
    @infinity = BigDecimal "Infinity"
    @infinity_minus = BigDecimal "-Infinity"
    @one_minus = BigDecimal "-1"
    @frac_1 = BigDecimal "1E-99999"
    @frac_2 = BigDecimal "0.9E-99999"

    @e3_minus = BigDecimal "3E-20001"
    @e = BigDecimal "1.00000000000000000000123456789"
    @tolerance = @e.sub @one, 1000
    @tolerance2 = BigDecimal "30001E-20005"

    @special_vals = [@infinity, @infinity_minus, @nan]
    @regular_vals = [ @one, @mixed, @pos_int, @neg_int,
                      @pos_frac, @neg_frac, @one_minus,
                      @frac_1, @frac_2
                    ]
    @zeroes = [@zero, @zero_pos, @zero_neg]
  end

  it "returns zero of appropriate sign if self or argument is zero" do
   # note @object is an array of size 0 , the non-existant precision arg to for a * b 
   # Maglev confusion on variable args to  selector :'*' , appending '*' results in send that
   # resolves to zero-arg '**' method which does not exist
    @zero.send(@method, @zero ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO  
    @zero_neg.send(@method, @zero_neg ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO
    @zero.send(@method, @zero_neg ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO # Maglev deviation, was SIGN_NEGATIVE_ZERO
    @zero_neg.send(@method, @zero ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO # Maglev deviation, was SIGN_NEGATIVE_ZERO

    @one.send(@method, @zero ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO
    @one.send(@method, @zero_neg ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO # Maglev deviation, was SIGN_NEGATIVE_ZERO

    @zero.send(@method, @one ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO
    @zero.send(@method, @one_minus ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO # Maglev deviation, was SIGN_NEGATIVE_ZERO
    @zero_neg.send(@method, @one_minus ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO
    @zero_neg.send(@method, @one ).sign.should == BigDecimal::SIGN_POSITIVE_ZERO # Maglev deviation, was SIGN_NEGATIVE_ZERO
  end

  it "returns NaN if NaN is involved" do
    values = @regular_vals + @zeroes

    values.each do |val|
      @nan.send(@method, val ).nan?.should == true
      val.send(@method, @nan ).nan?.should == true
    end
  end

  it "returns zero if self or argument is zero" do
    values = @regular_vals + @zeroes

    values.each do |val|
      @zeroes.each do |zero|
        zero.send(@method, val).should == 0
        zero.send(@method, val).zero?.should == true
        val.send(@method, zero).should == 0
        val.send(@method, zero).zero?.should == true
      end
    end
  end

  it "returns infinite value if self or argument is infinite" do
    values = @regular_vals
    infs = [@infinity, @infinity_minus]

    values.each do |val|
      infs.each do |inf|
        inf.send(@method, val).finite?.should == false
        val.send(@method, inf).finite?.should == false
      end
    end

    @infinity.send(@method, @infinity).infinite?.should == 1
    @infinity_minus.send(@method, @infinity_minus).infinite?.should == 1
    @infinity.send(@method, @infinity_minus).infinite?.should == -1
    @infinity_minus.send(@method, @infinity).infinite?.should == -1
    @infinity.send(@method, @one).infinite?.should == 1
    @infinity_minus.send(@method, @one).infinite?.should == -1
  end

  it "returns NaN if the result is undefined" do
    @zero.send(@method, @infinity).nan?.should == true
    @zero.send(@method, @infinity_minus).nan?.should == true
    @infinity.send(@method, @zero).nan?.should == true
    @infinity_minus.send(@method, @zero).nan?.should == true
  end
end