require File.expand_path('../../../spec_helper', __FILE__)

t_ver = "1.9"
deviates_on :maglev do 
  t_ver = "1.8.7"
end
describe "UnboundMethod#source_location" do
  ruby_version_is t_ver do
    it "needs to be reviewed for spec completeness"

    it "works for define_method methods" do
      line = nil
      cls = Class.new do
        line = __LINE__ + 1
        define_method(:foo) { }
      end
      
      method = cls.instance_method(:foo)
      method.source_location[0].should =~ /#{__FILE__}/
     not_compliant_on :maglev do 
      method.source_location[1].should == line
     end
     deviates_on :maglev do 
      method.source_location[1].should == 1
     end
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
      method.source_location[1].should == line
    end
  end 
 end
