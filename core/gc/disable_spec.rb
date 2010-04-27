require File.expand_path('../../../spec_helper', __FILE__)

describe "GC.disable" do
  after :each do
    GC.enable
  end

  it "returns true iff the garbage collection was previously disabled" do
    GC.disable.should == false
    GC.disable.should == false # maglev gc is always enabled , was == true
#   GC.disable.should == true
    GC.enable
    GC.disable.should == false
#   GC.disable.should == true  # maglev
  end

end
