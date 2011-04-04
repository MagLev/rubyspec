require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Numeric#divmod" do
  before(:each) do
    @obj = NumericSpecs::Subclass.new
  end

  ruby_version_is ""..."1.9" do
    it "returns [quotient, modulus], with quotient being obtained as in Numeric#div and modulus being obtained by calling self#% with other" do
     not_compliant_on :maglev do
      @obj.should_receive(:/).with(10).and_return(13 - TOLERANCE)
      @obj.should_receive(:%).with(10).and_return(3)
      @obj.divmod(10).should == [12, 3]
     end
     deviates_on :maglev do
       # Maglev, internal uses of / must use _divide() to avoid
       #   infinite recursion after  math.n redefines quo and / for Rational
       @obj.should_receive(:__divide).with(10).and_return(13 - TOLERANCE) 
       @obj.should_receive(:-).with(120).and_return(3)  # Maglev uses 1.9 style algorithm
       @obj.divmod(10).should == [12, 3]
     end
    end
  end

  ruby_version_is "1.9" do
    it "returns [quotient, modulus], with quotient being obtained as in Numeric#div then #floor and modulus being obtained by calling self#- with quotient * other" do
      @obj.should_receive(:/).twice.with(10).and_return(13 - TOLERANCE, 13 - TOLERANCE)
      @obj.should_receive(:-).with(120).and_return(3)

      @obj.divmod(10).should == [12, 3]
    end
  end
end
