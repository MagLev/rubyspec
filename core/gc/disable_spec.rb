require File.expand_path('../../../spec_helper', __FILE__)

describe "GC.disable" do
  after :each do
    GC.enable
  end

  it "returns true iff the garbage collection was previously disabled" do
    GC.disable.should == false
    not_compliant_on :maglev do
      GC.disable.should == true
      GC.disable.should == true
      GC.enable
      GC.disable.should == false
      GC.disable.should == true
    end
    deviates_on :maglev do
      # GC cannot be turned off
      GC.disable.should == false
      GC.enable
      GC.disable.should == false
    end
  end

end
