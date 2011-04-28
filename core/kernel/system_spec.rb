require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#system" do

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
    not_compliant_on :maglev do
      result = system("#{RUBY_EXE} -e 'exit(1)'")
      result.should be_false
    end
    deviates_on :maglev do
      # +d to ensure debug flag is off if running specs in debug mode
      result = system("#{RUBY_EXE} +d -e 'exit(1)'")
      result.should be_false
    end
  end

 not_compliant_on :maglev do # generalized IO.reopen not implem yet
  it "does not write to stderr when it can't find a command" do
    system("sad").should output_to_fd("") # nothing in stderr
  end  
 end

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

 not_compliant_on :maglev do #  not private yet
  it "is a private method" do
    Kernel.should have_private_instance_method(:system)
  end
 end

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
    result = system("#{RUBY_EXE} #{@helper_script} #{@shell_var} foo")
    result.should be_true
  end

  it "does not expand shell variables when given multiples arguments" do
    result = system("#{RUBY_EXE}", @helper_script, @shell_var, "foo")
    result.should be_false
  end
 end 
  
  platform_is :windows do
    ruby_bug 'redmine:4393', '1.9.3' do
      it "runs commands starting with @ using shell (as comments)" do
        # unsure of a better way to confirm this, since success means it does nothing
        result = system('@does_not_exist')
        result.should == true
      end
    end
  end
end

describe "Kernel.system" do
  it "needs to be reviewed for spec completeness"
end
