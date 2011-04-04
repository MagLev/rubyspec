require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Module#remove_class_variable" do
 not_compliant_on :maglev do  # cannot dup a Module
  it "removes class variable" do
    m = ModuleSpecs::MVars.dup
    m.class_variable_defined?(:@@mvar).should == true
    m.send(:remove_class_variable, :@@mvar)
    m.class_variable_defined?(:@@mvar).should == false
  end

  it "returns the value of removing class variable" do
    m = ModuleSpecs::MVars.dup
    m.send(:remove_class_variable, :@@mvar).should == :mvar
  end
 end

 deviates_on :maglev do 
  it "removes class variable" do
    # assume running with fresh transient state for each spec file, don't use dup
    m = ModuleSpecs::MVars  #   Module#dup not implemented  in maglev
    m.class_variable_defined?(:@@mvar).should == true
    m.send(:remove_class_variable, :@@mvar).should == :mvar
    m.class_variable_defined?(:@@mvar).should == false
  end
 end

  it "removes a class variable defined in a metaclass" do
    obj = mock("metaclass class variable")
    meta = obj.singleton_class
    meta.send :class_variable_set, :@@var, 1
    meta.send(:remove_class_variable, :@@var).should == 1
    meta.class_variable_defined?(:@@var).should be_false
  end

  it "raises a NameError when removing class variable declared in included module" do
    c = ModuleSpecs::RemoveClassVariable.new { include ModuleSpecs::MVars.dup }
    lambda { c.send(:remove_class_variable, :@@mvar) }.should raise_error(NameError)
  end

  it "raises a NameError when passed a symbol with one leading @" do
    lambda { ModuleSpecs::MVars.send(:remove_class_variable, :@mvar) }.should raise_error(NameError)
  end

  it "raises a NameError when passed a symbol with no leading @" do
    lambda { ModuleSpecs::MVars.send(:remove_class_variable, :mvar)  }.should raise_error(NameError)
  end

  it "raises a NameError when an uninitialized class variable is given" do
    lambda { ModuleSpecs::MVars.send(:remove_class_variable, :@@nonexisting_class_variable) }.should raise_error(NameError)
  end

  ruby_version_is "" ... "1.9" do
   not_compliant_on :maglev do #  not private yet
    it "is private" do
      Module.should have_private_instance_method(:remove_class_variable)
    end
   end
  end
end
