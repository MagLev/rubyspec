require File.expand_path('../../../spec_helper', __FILE__)

describe "Proc#arity" do
  it "returns the number of arguments, using Proc.new" do
   not_compliant_on :maglev do
    Proc.new { || }.arity.should == 0
   end
   deviates_on :maglev do
    Proc.new { || }.arity.should == -1
   end
    Proc.new { |a| }.arity.should == 1
    Proc.new { |_| }.arity.should == 1
    Proc.new { |a, b| }.arity.should == 2
    Proc.new { |a, b, c| }.arity.should == 3
  end

  it "returns the number of arguments, using Kernel#lambda" do
   not_compliant_on :maglev do
    lambda { || }.arity.should == 0
   end
   deviates_on :maglev do
    lambda { || }.arity.should == -1
   end
    lambda { |a| }.arity.should == 1
    lambda { |_| }.arity.should == 1
    lambda { |a, b| }.arity.should == 2
    lambda { |a, b, c| }.arity.should == 3
  end

  it "return the number of arguments, using Kernel#proc" do
   not_compliant_on :maglev do
    proc { || }.arity.should == 0
   end
   deviates_on :maglev do
    proc { || }.arity.should == -1
   end
    proc { |a| }.arity.should == 1
    proc { |_| }.arity.should == 1
    proc { |a, b| }.arity.should == 2
    proc { |a, b, c| }.arity.should == 3
  end

  it "if optional arguments, return the negative number of mandatory arguments using Proc.new " do
   not_compliant_on :maglev do
    Proc.new { |*| }.arity.should == -1
   end
   deviates_on :maglev do
    Proc.new { |*| }.arity.should == 0
   end
    Proc.new { |*a| }.arity.should == -1
    Proc.new { |a, *b| }.arity.should == -2
    Proc.new { |a, b, *c| }.arity.should == -3
  end

  it "if optional arguments, return the negative number of mandatory arguments using Kernel#lambda" do
   not_compliant_on :maglev do
    lambda { |*| }.arity.should == -1
   end
   deviates_on :maglev do
    lambda { |*| }.arity.should == 0
   end
    lambda { |*a| }.arity.should == -1
    lambda { |a, *b| }.arity.should == -2
    lambda { |a, b, *c| }.arity.should == -3
  end

  it "if optional arguments, return the negative number of mandatory arguments using Kernel#proc" do
   not_compliant_on :maglev do
    proc { |*| }.arity.should == -1
   end
   deviates_on :maglev do
    proc { |*| }.arity.should == 0
   end
    proc { |*a| }.arity.should == -1
    proc { |a, *b| }.arity.should == -2
    proc { |a, b, *c| }.arity.should == -3
  end

  ruby_version_is ""..."1.9" do
    it "returns -1 if no argument declaration is made, using Kernel#lambda" do
      lambda { }.arity.should == -1
    end

    it "returns -1 if no argument declaration is made, using Kernel#proc" do
      proc { }.arity.should == -1
    end

    it "returns -1 if no argument declaration is made, using Proc.new" do
      Proc.new { }.arity.should == -1
    end
  end

  ruby_version_is "1.9" do
    it "returns 0 if no argument declaration is made, using Kernel#lambda" do
      lambda { }.arity.should == 0
    end

    it "returns 0 if no argument declaration is made, using Kernel#proc" do
      proc { }.arity.should == 0
    end

    it "returns 0 if no argument declaration is made, using Proc.new" do
      Proc.new { }.arity.should == 0
    end
  end
end
