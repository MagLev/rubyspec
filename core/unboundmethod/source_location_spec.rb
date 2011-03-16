require File.expand_path('../../../spec_helper', __FILE__)

  describe "UnboundMethod#source_location" do
    it "needs to be reviewed for spec completeness"
    
ruby_version_is "" ... "1.9" do  # maglev, source_location in 1.8.7
    it "works for define_method methods" do
      line = nil
      cls = Class.new do
        line = __LINE__ + 1
        define_method(:foo) { }
      end
      
      method = cls.instance_method(:foo)
      method.source_location[0].should =~ /#{__FILE__}/
      method.source_location[1].should == 1 # maglev deviation # was == line
    end
end
    
ruby_version_is "1.9" do
    it "works for define_singleton_method methods" do
      line = nil
      cls = Class.new do
        line = __LINE__ + 1
        define_singleton_method(:foo) { }
      end
      
      method = cls.method(:foo)
      method.source_location[0].should =~ /#{__FILE__}/
      method.source_location[1].should == 1 # maglev deviation # was == line
    end
end 
  end
#end
