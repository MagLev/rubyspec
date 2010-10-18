require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#system" do
  before do
    @ruby = ENV['RUBY_EXE']
  end

  it "can run basic things that exist" do
    begin
      result = false

      File.exist?("happy").should == false
      result = system("echo a >> happy")
      result.should == true
      File.exist?("happy").should == true
    ensure
      File.unlink "happy"
    end
  end

  ruby_version_is ""..."1.9" do
    it "returns false when command execution fails" do
      result = system("sad")
      result.should == false
    end
  end

  ruby_version_is "1.9" do
    it "returns nil when command execution fails" do
      result = system("sad")
      result.should be_nil
    end
  end

  it "returns false when the command has a non-zero exit status" do
     # maglev +d to turn off debug flag
    result = system("#{RUBY_EXE} +d -e 'exit(1)'")
    result.should be_false
  end

# Maglev, output_to_fd not working yet, needs IO.reopen
# it "does not write to stderr when it can't find a command" do
#   system("sad").should output_to_fd("") # nothing in stderr
# end  

  it "uses /bin/sh if freaky shit is in the command" do
    begin
      result = false

      File.exist?("happy").should == false
      result = system("echo woot > happy")
      result.should == true
      File.exist?("happy").should == true
    ensure
      File.unlink "happy"
    end
  end

# Maglev, not private yet
# it "is a private method" do
#   Kernel.should have_private_instance_method(:system)
# end

  before :each do
    ENV['TEST_SH_EXPANSION'] = 'foo'
    @shell_var = '$TEST_SH_EXPANSION'
    platform_is :windows do
      @shell_var = '%TEST_SH_EXPANSION%'
    end

    @helper_script = KernelSpecs.helper_script
  end

not_compliant_on :maglev do
  it "expands shell variables when given a single string argument" do
    result = system("#{@ruby} #{@helper_script} #{@shell_var} foo")
    result.should be_true
  end
end
  
  it "does not expand shell variables when given multiples arguments" do 
    result = system("#{@ruby}", @helper_script, @shell_var, "foo")
    result.should be_false
  end
end

describe "Kernel.system" do
  it "needs to be reviewed for spec completeness"
end
