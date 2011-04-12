require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

t_ver = "1.9"
deviates_on :maglev do
  t_ver = "1.8.7"  # maglev, source_location implemented in 1.8.7
end

ruby_version_is t_ver do
  describe "Method#source_location" do
    before(:each) do
      @method = MethodSpecs::SourceLocation.method(:location)
    end

    it "returns nil for built-in methods" do
     not_compliant_on :maglev do
      File.method(:size).source_location.should be_nil
     end
     deviates_on :maglev do
      # location available for any non-primitive method 
      loc = File.method(:size).source_location
      loc[0].should == ENV['MAGLEV_HOME'] + '/src/kernel/bootstrap/File.rb'
      loc[1].should be_close(550, 50)
      File.method(:stdin).source_location.should be_nil # a ruby primitive 
     end
    end

    it "returns an Array" do
      @method.source_location.should be_an_instance_of(Array)
    end

    it "sets the first value to the path of the file in which the method was defined" do
      file = @method.source_location.first
      file.should be_an_instance_of(String)
      file.should == File.dirname(__FILE__) + '/fixtures/classes.rb'
    end

    it "sets the last value to a Fixnum representing the line on which the method was defined" do
      line = @method.source_location.last 
      line.should be_an_instance_of(Fixnum)
      line.should == 5 
    end

    it "returns the last place the method was defined" do
      MethodSpecs::SourceLocation.method(:redefined).source_location.last.should == 13
    end

    it "returns the location of the original method even if it was aliased" do
      MethodSpecs::SourceLocation.new.method(:aka).source_location.last.should == 17
    end
    
    it "works for define_method methods" do
      line = nil
      cls = Class.new do
        line = __LINE__ + 1
        define_method(:foo) { }
      end
      
      method = cls.new.method(:foo)
      method.source_location[0].should =~ /#{__FILE__}/
       method.source_location[1].should == line
    end
  end
end
