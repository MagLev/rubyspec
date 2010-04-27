require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#Array" do
# Maglev not private yet
# it "is a private method" do
#   Kernel.should have_private_instance_method(:Array)
# end
  
  it "does not call #to_ary on an Array" do
    obj = [1,2,3]
    obj.should_not_receive(:to_ary)

    Array(obj).should == [1, 2, 3]
  end

  it "tries to call #to_ary on the given argument if it's not an Array" do
    (obj = mock('[1,2,3]')).should_receive(:to_ary).and_return([1, 2, 3])
    obj.should_not_receive(:to_a)

    Array(obj).should == [1, 2, 3]
  end

  it "does not call #to_a on an Array" do
    obj = [1,2,3]
    obj.should_not_receive(:to_a)

    Array(obj).should == [1, 2, 3]
  end

  it "tries to call #to_a on the given argument if #to_ary is not provided" do
    (obj = mock('[4,5,6]')).should_receive(:to_a).and_return([4, 5, 6])
    Array(obj).should == [4, 5, 6]
  end
  
  it "returns an array with the given argument if neither #to_ary nor #to_a are provided" do
    obj = mock('x')
    Array(obj).should == [obj]
  end
  
  it "returns an empty array if the given argument is nil" do
    Array(nil).should == []
  end
  
  it "raises a TypeError if #to_ary / #to_a do not return an array" do
    (obj = mock('ha!')).should_receive(:to_a).and_return("ha!")
    lambda { Array(obj) }.should raise_error(TypeError)

    #obj.should_receive(:to_ary).and_return("ha!")
    #lambda { Array(obj) }.should raise_error(TypeError)
    # Maglev, attempts to_ary, then to_a without using respond_to?
    #   Mock framework not working right with respond_to?  ??
    (objb = mock('ha!')).should_receive(:to_a).and_return("ha!")
    objb.should_receive(:to_ary).and_return("ha!")
    lambda { Array(objb) }.should raise_error(TypeError)
  end
end

describe "Kernel.Array" do
  it "needs to be reviewed for spec completeness"
end
