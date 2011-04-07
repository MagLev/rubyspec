require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/common', __FILE__)

describe "Exception#backtrace" do
  before(:each) do
    @backtrace = ExceptionSpecs::Backtrace.backtrace
  end

  it "returns nil if no backtrace was set" do
    Exception.new.backtrace.should be_nil
  end

  it "returns an Array" do
    @backtrace.should be_an_instance_of(Array)
  end
  
  it "sets each element to a String" do
    @backtrace.each {|l| l.should be_an_instance_of(String)}
  end

  it "includes the filename of the location where self raised in the first element" do
    @backtrace.first.should =~ /common\.rb/
  end

  it "includes the line number of the location where self raised in the first element" do
   not_compliant_on :maglev do
    @backtrace.first.should =~ /:22:in /
   end
   deviates_on :maglev do
     @backtrace[1].should =~ /.*:20:in/ 
   end  
  end

  it "includes the name of the method from where self raised in the first element" do
   not_compliant_on :maglev do
    @backtrace.first.should =~ /in `backtrace'/
   end
   deviates_on :maglev do
    @backtrace[1].should =~ /in `backtrace'/
   end
  end

  it "includes the filename of the location immediately prior to where self raised in the second element" do
   not_compliant_on :maglev do
    @backtrace[1].should =~ /backtrace_spec\.rb/ 
   end
   deviates_on :maglev do
    @backtrace[3].should =~ /backtrace_spec\.rb/ 
   end
  end

  it "includes the line number of the location immediately prior to where self raised in the second element" do
   not_compliant_on :maglev do
    @backtrace[1].should =~ /:6(:in )?/
   end
   deviates_on :maglev do
    @backtrace[3].should =~ /:6(:in )?/
   end
  end

  it "contains lines of the same format for each prior position in the stack" do
    a_range = nil
    not_compliant_on :maglev do
     a_range = 2..-1
    end
    deviates_on :maglev do
     a_range = 4..-1
    end 
    @backtrace[a_range].each do |line| 
      # This regexp is deliberately imprecise to account for 1.9 using
      # absolute paths where 1.8 used relative paths, the need to abstract out
      # the paths of the included mspec files, the differences in output
      # between 1.8 and 1.9, and the desire to avoid specifying in any 
      # detail what the in `...' portion looks like.
      line.should =~ /^[^ ]+\:\d+(:in `[^`]+')?$/
    end
  end
end
