require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

not_compliant_on :maglev do
  # Maglev: this spec makes too many assumptions about the algorithm 
  #  chosen, and the maglev implementation does not work for arguments
  #  not a kind of Numeric .
  #  Numeric#remainder is covered by Bignum specs

describe "Numeric#remainder" do
  before(:each) do
    @obj    = NumericSpecs::Subclass.new
    @result = mock("Numeric#% result")
    @other  = mock("Passed Object")
  end

  it "returns the result of calling self#% with other if self is 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(true)

    @obj.remainder(@other).should equal(@result)
  end

  it "returns the result of calling self#% with other if self and other are greater than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(false)

    @obj.should_receive(:>).with(0).and_return(true)
    @other.should_receive(:<).with(0).and_return(false)

    @obj.remainder(@other).should equal(@result)
  end

  it "returns the result of calling self#% with other if self and other are less than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(true)
    @other.should_receive(:>).with(0).and_return(false)

    @obj.should_receive(:>).with(0).and_return(false)

    @obj.remainder(@other).should equal(@result)
  end

  it "returns the result of calling self#% with other - other if self is greater than 0 and other is less than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(false)

    @obj.should_receive(:>).with(0).and_return(true)
    @other.should_receive(:<).with(0).and_return(true)

    @result.should_receive(:-).with(@other).and_return(:result)

    @obj.remainder(@other).should == :result
  end

  it "returns the result of calling self#% with other - other if self is less than 0 and other is greater than 0" do
    @obj.should_receive(:%).with(@other).and_return(@result)
    @result.should_receive(:==).with(0).and_return(false)

    @obj.should_receive(:<).with(0).and_return(true)
    @other.should_receive(:>).with(0).and_return(true)

    @result.should_receive(:-).with(@other).and_return(:result)

    @obj.remainder(@other).should == :result
  end
end
end # maglev
