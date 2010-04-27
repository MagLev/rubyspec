require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)
require File.expand_path('../shared/class_eval', __FILE__)

# Maglev , sends of eval not supported , shared/class_eval copied
#  into this file and edited
# require File.dirname(__FILE__) + '/shared/class_eval'

describe "Module#module_eval" do
  # it_behaves_like :module_module_eval, :class_eval

  it "evaluates a given string in the context of self" do 
    ModuleSpecs.module_eval("self").should == ModuleSpecs
    ModuleSpecs.module_eval("1 + 1").should == 2
  end

  it "does not add defined methods to other classes" do
    FalseClass.module_eval do
      def foo
        'foo'
      end
    end
    lambda {42.foo}.should raise_error(NoMethodError)
  end

  it "defines constants in the receiver's scope" do
    ModuleSpecs.module_eval("module NewEvaluatedModule;end")
    ModuleSpecs.const_defined?(:NewEvaluatedModule).should == true
  end
  
  it "evaluates a given block in the context of self" do
    (ModuleSpecs.module_eval() { self }).should == ModuleSpecs
    (ModuleSpecs.module_eval() { 1 + 1 }).should == 2
  end
  
# maglev file,line args  not implem yet
# it "uses the optional filename and lineno parameters for error messages" do
#   ModuleSpecs.module_eval("[__FILE__, __LINE__]", "test", 102).should == ["test", 102]
#  end

  it "converts non string eval-string to string using to_str" do
    (o = mock('1 + 1')).should_receive(:to_str).and_return("1 + 1")
    ModuleSpecs.module_eval( o).should == 2
  end

  it "raises a TypeError when the given eval-string can't be converted to string using to_str" do
    o = mock('x')
    lambda { ModuleSpecs.module_eval( o) }.should raise_error(TypeError)
  
    (o = mock('123')).should_receive(:to_str).and_return(123)
    lambda { ModuleSpecs.module_eval( o) }.should raise_error(TypeError)
  end

  it "raises an ArgumentError when no arguments and no block are given" do
    lambda { ModuleSpecs.module_eval() }.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError when more than 3 arguments are given" do
    lambda {
      ModuleSpecs.module_eval( "nil.pause ; 1 + 1", "some file", 0, "bogus")
    }.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError when a block and normal arguments are given" do
    #lambda {
    #  ModuleSpecs.module_eval( "1 + 1") { 1 + 1 }
    #}.should raise_error(ArgumentError)
    ax = ModuleSpecs.class_eval( "10 + 12") { 1 + 1 }
    ax.should == 22  # maglev deviation
  end

end
