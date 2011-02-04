require File.expand_path('../spec_helper', __FILE__)

load_extension("numeric")

describe "CApiNumericSpecs" do
  before :each do
    @s = CApiNumericSpecs.new
  end

  describe "rb_num2long" do
#   it "rb_num2long raises an TypeError if passed nil" do	# do not checkin
#     lambda { @s.rb_num2long(nil) }.should raise_error(TypeError)
#   end

    it "converts a Float" do
      @s.rb_num2long(4.2).should == 4
    end

    it "converts a Bignum" do
      @s.rb_num2long(0x7fff_ffff).should == 0x7fff_ffff
    end

    it "converts a Fixnum" do
      @s.rb_num2long(5).should == 5
    end

    it "calls #to_int to coerce the value" do
      obj = mock("number")
      obj.should_receive(:to_int).and_return(2)
      @s.rb_num2long(obj).should == 2
    end
  end

  describe "rb_num2ulong" do
#   it "rb_num2ulong raises an TypeError if passed nil" do	# do not checkin
#     lambda { @s.rb_num2ulong(nil) }.should raise_error(TypeError)
#   end

    it "converts a Float" do
      @s.rb_num2ulong(4.2).should == 4
    end

    it "converts a Bignum" do
      @s.rb_num2ulong(0xffff_ffff).should == 0xffff_ffff
    end

    it "converts a Fixnum" do
      @s.rb_num2ulong(5).should == 5
    end

    it "calls #to_int to coerce the value" do
      obj = mock("number")
      obj.should_receive(:to_int).and_return(2)
      @s.rb_num2ulong(obj).should == 2
    end
  end

  describe "rb_Integer" do
    it "should create a new Integer from a String" do
      i = @s.rb_Integer("8675309")
      i.should be_kind_of(Integer)
      i.should eql(8675309)
    end
  end

 not_compliant_on :maglev do
  describe "rb_ll2inum" do
    it "should create a new Fixnum from a small signed long long" do
      i = @s.rb_ll2inum_14()
      i.should be_kind_of(Fixnum)
      i.should eql(14)
    end
  end
 end

  describe "rb_int2inum" do
    it "should create a new Fixnum from a long" do
      i = @s.rb_int2inum_14()
      i.should be_kind_of(Fixnum)
      i.should eql(14)
    end
  end

  describe "rb_num2dbl" do
#   it "rb_num2dbl raises an TypeError if passed nil" do   # do not checkin
#     lambda { @s.rb_num2dbl(nil) }.should raise_error(TypeError)
#   end

    it "raises an TypeError if passed a String" do
      lambda { @s.rb_num2dbl("1.2") }.should raise_error(TypeError)
    end

    it "converts a Float" do
      @s.rb_num2dbl(4.2).should == 4.2
    end

    it "converts a Bignum" do
      @s.rb_num2dbl(2**70).should == (2**70).to_f
    end

    it "converts a Fixnum" do
      @s.rb_num2dbl(5).should == 5.0
    end

    it "calls #to_f to coerce the value" do
      obj = mock("number")
      obj.should_receive(:to_f).and_return(2.0)
      @s.rb_num2dbl(obj).should == 2.0
    end
  end

  describe "NUM2CHR" do
    it "returns the first character of a String" do
      @s.NUM2CHR("Abc").should == 65
    end

    it "returns the least significant byte of an Integer" do
      @s.NUM2CHR(0xa7c).should == 0x07c
    end

    it "returns the least significant byte of a Float converted to an Integer" do
      @s.NUM2CHR(0xa7c.to_f).should == 0x07c
    end

    it "raises a TypeError when passed an empty String" do
      lambda { @s.NUM2CHR("") }.should raise_error(TypeError)
    end
  end

  describe "rb_num_zerodiv" do
    it "raises a RuntimeError" do
      lambda { @s.rb_num_zerodiv() }.should raise_error(ZeroDivisionError, 'divided by 0')
    end
  end

  describe "rb_cmpint" do
    it "returns a Fixnum if passed one" do
      @s.rb_cmpint(1, 2).should == 1
    end

    it "uses > to check if the value is greater than 1" do
      m = mock("number")
      m.should_receive(:>).and_return(true)
      @s.rb_cmpint(m, 4).should == 1
    end

    it "uses < to check if the value is less than 1" do
      m = mock("number")
      m.should_receive(:>).and_return(false)
      m.should_receive(:<).and_return(true)
      @s.rb_cmpint(m, 4).should == -1
    end

    it "returns 0 if < and > are false" do
      m = mock("number")
      m.should_receive(:>).and_return(false)
      m.should_receive(:<).and_return(false)
      @s.rb_cmpint(m, 4).should == 0
    end

    it "raises an ArgumentError when passed nil" do
      lambda {
        @s.rb_cmpint(nil, 4)
      }.should raise_error(ArgumentError)
    end
  end
end
