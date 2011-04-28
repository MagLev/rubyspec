require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#binding" do
 not_compliant_on :maglev do #  not private yet
  it "is a private method" do
    Kernel.should have_private_instance_method(:binding)
  end
 end
  
  before(:each) do
    @b1 = KernelSpecs::Binding.new(99).get_binding
    ScratchPad.clear
  end

  it "returns a Binding object" do
    @b1.kind_of?(Binding).should == true
  end

  it "encapsulates the execution context properly" do
    eval("@secret", @b1).should == 100
    eval("a", @b1).should == true
    eval("b", @b1).should == true
    eval("@@super_secret", @b1).should == "password"

    eval("square(2)", @b1).should == 4
    eval("self.square(2)", @b1).should == 4

    eval("a = false", @b1)
    eval("a", @b1).should == false
  end

  it "raises a NameError on undefined variable" do
    lambda { eval("a_fake_variable", @b1) }.should raise_error(NameError)
  end

  ruby_version_is ""..."1.9" do
   not_compliant_on :maglev do  # send of binding not supported
    it "uses the receiver of #binding as self in the binding" do
      m = mock(:whatever)
      eval('self', m.send(:binding)).should == m
    end

    it "uses the receiver of #binding as self in a Class.new block" do
      m = mock(:whatever)
      cls = Class.new { ScratchPad.record eval('self', m.send(:binding)) }
      ScratchPad.recorded.should == m
    end
   end
  end

  ruby_version_is "1.9" do
    it "uses the closure's self as self in the binding" do
      m = mock(:whatever)
      eval('self', m.send(:binding)).should == self
    end

    it "uses the class as self in a Class.new block" do
      m = mock(:whatever)
      cls = Class.new { ScratchPad.record eval('self', m.send(:binding)) }
      ScratchPad.recorded.should == cls
    end
  end
end
