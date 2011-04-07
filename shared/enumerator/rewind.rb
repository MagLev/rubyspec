require File.expand_path('../../../spec_helper', __FILE__)

describe :enum_rewind, :shared => true do

  before(:each) do
   not_compliant_on :maglev do
    @enum = enumerator_class.new(1, :upto, 3)
   end
   deviates_on :maglev do
    @enum = 1.upto(3)	# new is subclass responsibility, use a NumericEnumerator
   end
  end  

  it "resets the enumerator to its initial state" do
    @enum.next.should == 1
    @enum.next.should == 2
    @enum.rewind
    @enum.next.should == 1
  end

  it "returns self" do
    @enum.rewind.should == @enum
  end

  it "has no effect on a new enumerator" do
    @enum.rewind
    @enum.next.should == 1
  end

  it "has no effect if called multiple, consecutive times" do
    @enum.next.should == 1
    @enum.rewind
    @enum.rewind
    @enum.next.should == 1
  end
  
end
