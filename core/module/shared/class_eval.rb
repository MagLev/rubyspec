# Maglev fails,  sends of class_eval or module_eval not supported
#  This file copied to core/module/class_eval_spec.rb and
#    to core/module/module_eval_spec.rb 

  it "evaluates a given string in the context of self" do
    ModuleSpecs.send(@method, "self").should == ModuleSpecs
    ModuleSpecs.send(@method, "1 + 1").should == 2
  end

  it "does not add defined methods to other classes" do
    FalseClass.class_eval do
      def foo
        'foo'
      end
    end
    lambda {42.foo}.should raise_error(NoMethodError)
  end

  it "defines constants in the receiver's scope" do
    ModuleSpecs.send(@method, "module NewEvaluatedModule;end")
    ModuleSpecs.const_defined?(:NewEvaluatedModule).should == true
  end
  
  it "evaluates a given block in the context of self" do
    ModuleSpecs.send(@method) { self }.should == ModuleSpecs
    ModuleSpecs.send(@method) { 1 + 1 }.should == 2
  end
  
  it "uses the optional filename and lineno parameters for error messages" do
    ModuleSpecs.send(@method, "[__FILE__, __LINE__]", "test", 102).should == ["test", 102]
  end

  it "converts a non-string filename to a string using to_str" do
    (file = mock(__FILE__)).should_receive(:to_str).and_return(__FILE__)
    ModuleSpecs.send(@method, "1+1", file)
  end

  it "raises a TypeError when the given filename can't be converted to string using to_str" do
    (file = mock('123')).should_receive(:to_str).and_return(123)
    lambda { ModuleSpecs.send(@method, "1+1", file) }.should raise_error(TypeError)
  end

  it "converts non string eval-string to string using to_str" do
    (o = mock('1 + 1')).should_receive(:to_str).and_return("1 + 1")
    ModuleSpecs.send(@method, o).should == 2
  end

  it "raises a TypeError when the given eval-string can't be converted to string using to_str" do
    o = mock('x')
    lambda { ModuleSpecs.send(@method, o) }.should raise_error(TypeError)
  
    (o = mock('123')).should_receive(:to_str).and_return(123)
    lambda { ModuleSpecs.send(@method, o) }.should raise_error(TypeError)
  end

  it "raises an ArgumentError when no arguments and no block are given" do
    lambda { ModuleSpecs.send(@method) }.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError when more than 3 arguments are given" do
    lambda {
      ModuleSpecs.send(@method, "1 + 1", "some file", 0, "bogus")
    }.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError when a block and normal arguments are given" do
    lambda {
      ModuleSpecs.send(@method, "1 + 1") { 1 + 1 }
    }.should raise_error(ArgumentError)
  end
end
